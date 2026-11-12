"""
FloodGuard Malaysia - Data Preprocessing
CRISP-DM Phase 3: Data Preparation

Merges 5 datasets, engineers features, creates flood risk label,
applies SMOTE, and saves master_training.csv to Data/Processed/
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import LabelEncoder
from imblearn.over_sampling import SMOTE
import os
import warnings
warnings.filterwarnings('ignore')

# ── PATHS ──────────────────────────────────────────────────────────────────
RAW = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Data", "Raw")
OUT = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Data", "Processed")
os.makedirs(OUT, exist_ok=True)

TARGET_STATES = ['Kelantan', 'Terengganu', 'Selangor', 'Johor']

print("=" * 60)
print("FloodGuard Malaysia - Data Preprocessing")
print("=" * 60)

# ── STEP 1: LOAD DATASETS ──────────────────────────────────────────────────
print("\n[1/7] Loading datasets...")

rainfall = pd.read_csv(os.path.join(RAW, "FloodGuard_Rainfall_Weather_Dataset.csv"))
river    = pd.read_csv(os.path.join(RAW, "FloodGuard_River_Hydrology_Dataset.csv"))
flood_master = pd.read_csv(os.path.join(RAW, "malaysia_flood_master.csv"))
flood_hist   = pd.read_csv(os.path.join(RAW, "_MalaysiaFloodDataset_MalaysiaFloodDataset.csv"))
flood_risk   = pd.read_csv(os.path.join(RAW, "flood.csv"))

print(f"  Rainfall dataset:      {rainfall.shape}")
print(f"  River dataset:         {river.shape}")
print(f"  Malaysia flood master: {flood_master.shape}")
print(f"  Flood history:         {flood_hist.shape}")
print(f"  Flood risk factors:    {flood_risk.shape}")

# ── STEP 2: FILTER TO 4 TARGET STATES ─────────────────────────────────────
print("\n[2/7] Filtering to target states: Kelantan, Terengganu, Selangor, Johor...")

rainfall = rainfall[rainfall['State'].isin(TARGET_STATES)].copy()
river    = river[river['State'].isin(TARGET_STATES)].copy()

print(f"  Rainfall after filter: {rainfall.shape}")
print(f"  River after filter:    {river.shape}")

# ── STEP 3: STANDARDISE DATE AND MERGE RAINFALL + RIVER ───────────────────
print("\n[3/7] Merging rainfall and river datasets...")

rainfall['Date'] = pd.to_datetime(rainfall['Date'])
river['Date']    = pd.to_datetime(river['Date'])

# Merge on Date, State, District
merged = pd.merge(
    rainfall[['Date', 'Year', 'Month', 'State', 'District', 'Season',
              'Rainfall_mm', 'Temperature_C', 'Humidity_pct',
              'Wind_Speed_kmh', 'Cloud_Cover_pct', 'Weather_Condition']],
    river[['Date', 'State', 'District', 'River_Name',
           'Water_Level_m', 'Water_Discharge_m3s', 'Flow_Rate',
           'Alert_Level', 'Status']],
    on=['Date', 'State', 'District'],
    how='inner'
)

print(f"  Merged shape: {merged.shape}")

# ── STEP 4: FEATURE ENGINEERING ───────────────────────────────────────────
print("\n[4/7] Engineering features...")

# Monsoon flag (Northeast monsoon: Nov-Mar, Southwest: May-Sep)
merged['Is_Monsoon'] = merged['Month'].apply(
    lambda m: 1 if m in [11, 12, 1, 2, 3] else 0
)

# 7-day rolling rainfall (per State + District)
merged = merged.sort_values(['State', 'District', 'Date'])
merged['Rainfall_7day_rolling'] = (
    merged.groupby(['State', 'District'])['Rainfall_mm']
    .transform(lambda x: x.rolling(7, min_periods=1).mean())
)

# Water level category
merged['Water_Level_Category'] = pd.cut(
    merged['Water_Level_m'],
    bins=[0, 1.5, 3.0, 5.0, 999],
    labels=['Low', 'Normal', 'High', 'Critical']
)

# Alert level encoding
alert_map = {'Normal': 0, 'Alert': 1, 'Warning': 2, 'Danger': 3}
merged['Alert_Level_Encoded'] = merged['Alert_Level'].map(alert_map).fillna(0)

# Season encoding
season_map = {'Dry': 0, 'Wet': 1, 'Northeast Monsoon': 2, 'Southwest Monsoon': 1}
merged['Season_Encoded'] = merged['Season'].map(season_map).fillna(0)

print(f"  Features added: Is_Monsoon, Rainfall_7day_rolling, Water_Level_Category,")
print(f"                  Alert_Level_Encoded, Season_Encoded")

# ── STEP 5: CREATE FLOOD RISK LABEL ───────────────────────────────────────
print("\n[5/7] Creating flood risk label (Low / Medium / High)...")

def assign_flood_risk(row):
    score = 0
    if row['Rainfall_mm'] > 100:
        score += 2
    elif row['Rainfall_mm'] > 50:
        score += 1
    if row['Water_Level_m'] > 5:
        score += 3
    elif row['Water_Level_m'] > 3:
        score += 2
    elif row['Water_Level_m'] > 1.5:
        score += 1
    if row['Alert_Level_Encoded'] >= 2:
        score += 2
    elif row['Alert_Level_Encoded'] == 1:
        score += 1
    if row['Is_Monsoon'] == 1:
        score += 1
    if score >= 5:
        return 'High'
    elif score >= 2:
        return 'Medium'
    else:
        return 'Low'

merged['Flood_Risk'] = merged.apply(assign_flood_risk, axis=1)

print("  Flood risk distribution:")
print(merged['Flood_Risk'].value_counts().to_string())

# ── STEP 6: MISSING VALUES ─────────────────────────────────────────────────
print("\n[6/7] Checking and handling missing values...")

missing_before = merged.isnull().sum().sum()
print(f"  Missing values before: {missing_before}")

# Fill numeric columns with median
num_cols = merged.select_dtypes(include=[np.number]).columns
merged[num_cols] = merged[num_cols].fillna(merged[num_cols].median())

# Fill categorical with mode
cat_cols = ['Weather_Condition', 'Water_Level_Category', 'Alert_Level', 'Status']
for col in cat_cols:
    if col in merged.columns:
        merged[col] = merged[col].fillna(merged[col].mode()[0])

missing_after = merged.isnull().sum().sum()
print(f"  Missing values after:  {missing_after}")

# ── STEP 7: PREPARE FINAL DATASET AND APPLY SMOTE ─────────────────────────
print("\n[7/7] Preparing final dataset and applying SMOTE...")

# Select features for ML
feature_cols = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

# Encode target
le = LabelEncoder()
merged['Flood_Risk_Encoded'] = le.fit_transform(merged['Flood_Risk'])

X = merged[feature_cols]
y = merged['Flood_Risk_Encoded']

print(f"  Class distribution before SMOTE: {dict(zip(le.classes_, np.bincount(y)))}")

# Apply SMOTE
smote = SMOTE(random_state=42)
X_resampled, y_resampled = smote.fit_resample(X, y)

print(f"  Class distribution after SMOTE:  {dict(zip(le.classes_, np.bincount(y_resampled)))}")

# Build final dataframe
final_df = pd.DataFrame(X_resampled, columns=feature_cols)
final_df['Flood_Risk_Encoded'] = y_resampled
final_df['Flood_Risk'] = le.inverse_transform(y_resampled)

# ── SAVE OUTPUTS ───────────────────────────────────────────────────────────
master_path = os.path.join(OUT, "master_training.csv")
final_df.to_csv(master_path, index=False)
print(f"\n  Saved: master_training.csv {final_df.shape}")

# Also save the pre-SMOTE merged dataset for EDA reference
merged.to_csv(os.path.join(OUT, "merged_clean.csv"), index=False)
print(f"  Saved: merged_clean.csv {merged.shape}")

# ── PLOTS (SCREENSHOT THESE FOR YOUR REPORT) ──────────────────────────────
print("\nGenerating plots...")

# Plot 1: Flood risk distribution
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
fig.suptitle('FloodGuard Malaysia - Flood Risk Distribution', fontsize=14)

merged['Flood_Risk'].value_counts().plot(
    kind='bar', ax=axes[0], color=['green', 'orange', 'red'],
    title='Before SMOTE'
)
axes[0].set_xlabel('Flood Risk Level')
axes[0].set_ylabel('Count')

final_df['Flood_Risk'].value_counts().plot(
    kind='bar', ax=axes[1], color=['green', 'orange', 'red'],
    title='After SMOTE'
)
axes[1].set_xlabel('Flood Risk Level')
axes[1].set_ylabel('Count')

plt.tight_layout()
plot1_path = os.path.join(OUT, "plot_flood_risk_distribution.png")
plt.savefig(plot1_path, dpi=150)
plt.show()
print(f"  Saved: plot_flood_risk_distribution.png")

# Plot 2: Rainfall by State
fig, ax = plt.subplots(figsize=(10, 5))
merged.groupby('State')['Rainfall_mm'].mean().plot(
    kind='bar', ax=ax, color='steelblue',
    title='Average Rainfall by State (mm)'
)
ax.set_xlabel('State')
ax.set_ylabel('Average Rainfall (mm)')
plt.tight_layout()
plot2_path = os.path.join(OUT, "plot_rainfall_by_state.png")
plt.savefig(plot2_path, dpi=150)
plt.show()
print(f"  Saved: plot_rainfall_by_state.png")

# Plot 3: Water level distribution
fig, ax = plt.subplots(figsize=(10, 5))
merged['Water_Level_m'].hist(bins=30, ax=ax, color='steelblue', edgecolor='black')
ax.set_title('Water Level Distribution (m)')
ax.set_xlabel('Water Level (m)')
ax.set_ylabel('Frequency')
plt.tight_layout()
plot3_path = os.path.join(OUT, "plot_water_level_distribution.png")
plt.savefig(plot3_path, dpi=150)
plt.show()
print(f"  Saved: plot_water_level_distribution.png")

print("\n" + "=" * 60)
print("Preprocessing complete.")
print(f"master_training.csv is ready for ML model training.")
print("=" * 60)
print("\n*** SCREENSHOT THIS TERMINAL OUTPUT FOR YOUR REPORT ***")