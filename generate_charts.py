

import pandas as pd
import numpy as np
import json
import os
import matplotlib
matplotlib.use('Agg')  # remove this line if you want plots to pop up interactively
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from sklearn.ensemble import RandomForestClassifier, RandomForestRegressor
from sklearn.metrics import (accuracy_score, precision_score, recall_score, f1_score,
                              confusion_matrix, mean_absolute_error, mean_squared_error, r2_score)

# CONFIG 
CSV_PATH =CSV_PATH = r"C:\Users\user\OneDrive\Documents\MAY 26 SEMESTER\DM\DM Assignment\retail_data.csv"   # path to the full dataset
OUTPUT_DIR = "figs"              # folder where charts will be saved
SAMPLE_N = 150000                # rows to sample for training (use None to use the full dataset)
RANDOM_STATE = 42

os.makedirs(OUTPUT_DIR, exist_ok=True)
np.random.seed(RANDOM_STATE)
RESULTS = {}

# 1. LOAD DATA
print("Loading data...")
df = pd.read_csv(CSV_PATH)
print("Full dataset shape:", df.shape)

RESULTS['n_rows_raw'] = df.shape[0]
RESULTS['n_cols_raw'] = df.shape[1]
RESULTS['duplicates_found'] = int(df.duplicated().sum())
RESULTS['missing_values_found'] = int(df.isnull().sum().sum())

# 2. SAMPLE
if SAMPLE_N is not None and SAMPLE_N < len(df):
    df_s = df.sample(n=SAMPLE_N, random_state=RANDOM_STATE).reset_index(drop=True)
else:
    df_s = df.copy()
print("Working sample shape:", df_s.shape)
RESULTS['sample_size_used'] = df_s.shape[0]

# 3. FEATURE PREPARATION
drop_cols = ['customer_id', 'transaction_id', 'product_id', 'transaction_date',
             'last_purchase_date', 'product_manufacture_date', 'product_expiry_date',
             'promotion_id', 'promotion_start_date', 'promotion_end_date',
             'customer_zip_code', 'store_zip_code']
work = df_s.drop(columns=[c for c in drop_cols if c in df_s.columns])

cat_cols = work.select_dtypes(include='object').columns.tolist()
cat_cols_enc = [c for c in cat_cols if c != 'churned']  # keep target out of encoding loop

work_enc = work.copy()
for c in cat_cols_enc:
    le = LabelEncoder()
    work_enc[c] = le.fit_transform(work_enc[c].astype(str))

work_enc['churned_bin'] = (work['churned'] == 'Yes').astype(int)

# 4. TASK 1 - CHURN CLASSIFICATION
print("Training churn classification model...")
feature_cols_churn = [c for c in work_enc.columns if c not in ['churned', 'churned_bin']]
X = work_enc[feature_cols_churn]
y = work_enc['churned_bin']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=RANDOM_STATE, stratify=y
)

clf = RandomForestClassifier(
    n_estimators=100, max_depth=10, min_samples_leaf=5,
    n_jobs=-1, random_state=RANDOM_STATE, class_weight='balanced'
)
clf.fit(X_train, y_train)
y_pred = clf.predict(X_test)

acc = accuracy_score(y_test, y_pred)
prec = precision_score(y_test, y_pred)
rec = recall_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred)
cm = confusion_matrix(y_test, y_pred)

RESULTS['churn'] = {
    'accuracy': acc, 'precision': prec, 'recall': rec, 'f1': f1,
    'confusion_matrix': cm.tolist(),
    'train_size': len(X_train), 'test_size': len(X_test),
}
print(f"Churn model -> accuracy={acc:.4f} precision={prec:.4f} recall={rec:.4f} f1={f1:.4f}")

fi_churn = pd.Series(clf.feature_importances_, index=feature_cols_churn).sort_values(ascending=False)
RESULTS['churn']['top_features'] = fi_churn.head(15).to_dict()

# --- Chart: Confusion matrix ---
fig, ax = plt.subplots(figsize=(4.5, 4))
ax.imshow(cm, cmap='Blues')
for i in range(2):
    for j in range(2):
        ax.text(j, i, str(cm[i, j]), ha='center', va='center',
                color='white' if cm[i, j] > cm.max() / 2 else 'black', fontsize=13)
ax.set_xticks([0, 1]); ax.set_yticks([0, 1])
ax.set_xticklabels(['Not Churned', 'Churned'])
ax.set_yticklabels(['Not Churned', 'Churned'])
ax.set_xlabel('Predicted'); ax.set_ylabel('Actual')
ax.set_title('Confusion Matrix - Churn Model')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/confusion_matrix.png', dpi=150)
plt.close()

# --- Chart: Feature importance (churn) ---
fig, ax = plt.subplots(figsize=(7, 5))
top10 = fi_churn.head(10).sort_values()
ax.barh(top10.index, top10.values, color='#2c6e91')
ax.set_xlabel('Importance')
ax.set_title('Top 10 Feature Importances - Churn Classification')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/feature_importance_churn.png', dpi=150)
plt.close()

# 5. TASK 2 - SALES REGRESSION
print("Training sales regression model...")
feature_cols_reg = [c for c in work_enc.columns if c not in ['total_sales', 'churned', 'churned_bin']]
Xr = work_enc[feature_cols_reg]
yr = work_enc['total_sales']

Xr_train, Xr_test, yr_train, yr_test = train_test_split(
    Xr, yr, test_size=0.2, random_state=RANDOM_STATE
)

reg = RandomForestRegressor(
    n_estimators=100, max_depth=10, min_samples_leaf=5,
    n_jobs=-1, random_state=RANDOM_STATE
)
reg.fit(Xr_train, yr_train)
yr_pred = reg.predict(Xr_test)

mae = mean_absolute_error(yr_test, yr_pred)
rmse = mean_squared_error(yr_test, yr_pred) ** 0.5
r2 = r2_score(yr_test, yr_pred)

RESULTS['regression'] = {
    'mae': mae, 'rmse': rmse, 'r2': r2,
    'train_size': len(Xr_train), 'test_size': len(Xr_test),
    'target_mean': float(yr.mean()), 'target_std': float(yr.std())
}
print(f"Regression model -> MAE={mae:.2f} RMSE={rmse:.2f} R2={r2:.4f}")

fi_reg = pd.Series(reg.feature_importances_, index=feature_cols_reg).sort_values(ascending=False)
RESULTS['regression']['top_features'] = fi_reg.head(15).to_dict()

# (regression) 
fig, ax = plt.subplots(figsize=(7, 5))
top10r = fi_reg.head(10).sort_values()
ax.barh(top10r.index, top10r.values, color='#b06d2c')
ax.set_xlabel('Importance')
ax.set_title('Top 10 Feature Importances - Sales Regression')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/feature_importance_regression.png', dpi=150)
plt.close()

idx = np.random.choice(len(yr_test), size=min(3000, len(yr_test)), replace=False)
fig, ax = plt.subplots(figsize=(6, 6))
ax.scatter(np.array(yr_test)[idx], yr_pred[idx], alpha=0.25, s=10, color='#2c6e91')
lims = [min(yr_test.min(), yr_pred.min()), max(yr_test.max(), yr_pred.max())]
ax.plot(lims, lims, color='red', linewidth=1, linestyle='--')
ax.set_xlabel('Actual total_sales')
ax.set_ylabel('Predicted total_sales')
ax.set_title('Actual vs Predicted Sales')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/actual_vs_predicted.png', dpi=150)
plt.close()

# 6. SUPPORTING EDA CHARTS
# --- Chart: Correlation heatmap ---
num_cols_small = ['age', 'membership_years', 'quantity', 'unit_price', 'discount_applied',
                   'avg_purchase_value', 'online_purchases', 'in_store_purchases',
                   'total_transactions', 'total_sales', 'customer_support_calls',
                   'days_since_last_purchase', 'distance_to_store']
num_cols_small = [c for c in num_cols_small if c in df_s.columns]
corr = df_s[num_cols_small].corr()
fig, ax = plt.subplots(figsize=(8, 7))
im = ax.imshow(corr, cmap='coolwarm', vmin=-1, vmax=1)
ax.set_xticks(range(len(num_cols_small))); ax.set_yticks(range(len(num_cols_small)))
ax.set_xticklabels(num_cols_small, rotation=90, fontsize=8)
ax.set_yticklabels(num_cols_small, fontsize=8)
plt.colorbar(im, ax=ax, fraction=0.046, pad=0.04)
ax.set_title('Correlation Heatmap - Key Numeric Variables')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/correlation_heatmap.png', dpi=150)
plt.close()

# --- Chart: Churn rate by income bracket ---
churn_by_income = df_s.groupby('income_bracket')['churned'].apply(lambda x: (x == 'Yes').mean())
fig, ax = plt.subplots(figsize=(5, 4))
ax.bar(churn_by_income.index, churn_by_income.values, color='#5a9367')
ax.set_ylim(0, 0.6)
ax.set_ylabel('Churn Rate')
ax.set_title('Churn Rate by Income Bracket')
for i, v in enumerate(churn_by_income.values):
    ax.text(i, v + 0.01, f"{v:.1%}", ha='center')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/churn_by_income.png', dpi=150)
plt.close()

# --- Chart: total_sales distribution ---
fig, ax = plt.subplots(figsize=(6, 4))
ax.hist(df_s['total_sales'], bins=50, color='#2c6e91')
ax.set_xlabel('total_sales')
ax.set_ylabel('Frequency')
ax.set_title('Distribution of total_sales')
plt.tight_layout()
plt.savefig(f'{OUTPUT_DIR}/total_sales_distribution.png', dpi=150)
plt.close()

# 7. SAVE METRICS
with open('results.json', 'w') as f:
    json.dump(RESULTS, f, indent=2, default=str)

print("\nAll charts saved to:", OUTPUT_DIR)
print("Metrics saved to: results.json")
print("DONE")
