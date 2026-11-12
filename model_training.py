"""
FloodGuard Malaysia - ML Model Training
CRISP-DM Phase 4: Modeling

Trains Random Forest, XGBoost, and Logistic Regression.
Compares performance and saves the best model.
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
import joblib
import warnings
warnings.filterwarnings('ignore')

from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (accuracy_score, precision_score, recall_score,
                             f1_score, classification_report, confusion_matrix)
from xgboost import XGBClassifier

# ── PATHS ──────────────────────────────────────────────────────────────────
PROCESSED = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Data", "Processed")
MODELS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Models")
os.makedirs(MODELS, exist_ok=True)

print("=" * 60)
print("FloodGuard Malaysia - ML Model Training")
print("=" * 60)

# ── STEP 1: LOAD DATA ──────────────────────────────────────────────────────
print("\n[1/6] Loading master_training.csv...")

df = pd.read_csv(os.path.join(PROCESSED, "master_training.csv"))
print(f"  Shape: {df.shape}")
print(f"  Columns: {df.columns.tolist()}")
print(f"  Class distribution:\n{df['Flood_Risk'].value_counts().to_string()}")

# ── STEP 2: PREPARE FEATURES AND LABELS ───────────────────────────────────
print("\n[2/6] Preparing features and labels...")

feature_cols = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

X = df[feature_cols]
y = df['Flood_Risk_Encoded']

# Train/test split 80/20
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"  Training set: {X_train.shape}")
print(f"  Test set:     {X_test.shape}")

# ── STEP 3: TRAIN 3 MODELS ─────────────────────────────────────────────────
print("\n[3/6] Training models...")

models = {
    'Random Forest': RandomForestClassifier(n_estimators=100, random_state=42, n_jobs=-1),
    'XGBoost': XGBClassifier(n_estimators=100, random_state=42,
                              eval_metric='mlogloss', verbosity=0),
    'Logistic Regression': LogisticRegression(max_iter=1000, random_state=42)
}

results = {}

for name, model in models.items():
    print(f"\n  Training {name}...")
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)

    acc  = accuracy_score(y_test, y_pred)
    prec = precision_score(y_test, y_pred, average='weighted')
    rec  = recall_score(y_test, y_pred, average='weighted')
    f1   = f1_score(y_test, y_pred, average='weighted')

    results[name] = {
        'model': model,
        'y_pred': y_pred,
        'Accuracy': round(acc, 4),
        'Precision': round(prec, 4),
        'Recall': round(rec, 4),
        'F1-Score': round(f1, 4)
    }

    print(f"  Accuracy:  {acc:.4f}")
    print(f"  Precision: {prec:.4f}")
    print(f"  Recall:    {rec:.4f}")
    print(f"  F1-Score:  {f1:.4f}")

# ── STEP 4: COMPARE MODELS ─────────────────────────────────────────────────
print("\n[4/6] Model comparison:")
print("-" * 55)
print(f"{'Model':<25} {'Accuracy':>9} {'Precision':>10} {'Recall':>8} {'F1':>8}")
print("-" * 55)

best_model_name = None
best_f1 = 0

for name, r in results.items():
    print(f"{name:<25} {r['Accuracy']:>9} {r['Precision']:>10} {r['Recall']:>8} {r['F1-Score']:>8}")
    if r['F1-Score'] > best_f1:
        best_f1 = r['F1-Score']
        best_model_name = name

print("-" * 55)
print(f"\n  Best model: {best_model_name} (F1: {best_f1})")

# ── STEP 5: SAVE BEST MODEL ────────────────────────────────────────────────
print("\n[5/6] Saving best model...")

best_model = results[best_model_name]['model']
model_path = os.path.join(MODELS, "best_model.pkl")
joblib.dump(best_model, model_path)
print(f"  Saved: best_model.pkl ({best_model_name})")

# Save model name for reference
with open(os.path.join(MODELS, "best_model_name.txt"), "w") as f:
    f.write(best_model_name)

# ── STEP 6: GENERATE CHARTS ────────────────────────────────────────────────
print("\n[6/6] Generating charts...")

label_names = ['High', 'Low', 'Medium']

# Chart 1: Model comparison bar chart
metrics_df = pd.DataFrame({
    name: {k: v for k, v in r.items() if k != 'model' and k != 'y_pred'}
    for name, r in results.items()
}).T

fig, ax = plt.subplots(figsize=(10, 6))
metrics_df[['Accuracy', 'Precision', 'Recall', 'F1-Score']].plot(
    kind='bar', ax=ax, colormap='Set2', edgecolor='black'
)
ax.set_title('Model Performance Comparison', fontsize=14)
ax.set_xlabel('Model')
ax.set_ylabel('Score')
ax.set_ylim(0, 1.1)
ax.legend(loc='lower right')
ax.set_xticklabels(ax.get_xticklabels(), rotation=15)
for container in ax.containers:
    ax.bar_label(container, fmt='%.2f', fontsize=7, padding=2)
plt.tight_layout()
plt.savefig(os.path.join(PROCESSED, "plot_model_comparison.png"), dpi=150)
plt.show()
print("  Saved: plot_model_comparison.png")

# Chart 2: Confusion matrix for best model
fig, ax = plt.subplots(figsize=(7, 6))
cm = confusion_matrix(y_test, results[best_model_name]['y_pred'])
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues',
            xticklabels=label_names, yticklabels=label_names, ax=ax)
ax.set_title(f'Confusion Matrix - {best_model_name}', fontsize=13)
ax.set_xlabel('Predicted')
ax.set_ylabel('Actual')
plt.tight_layout()
plt.savefig(os.path.join(PROCESSED, "plot_confusion_matrix.png"), dpi=150)
plt.show()
print("  Saved: plot_confusion_matrix.png")

# Chart 3: Feature importance (Random Forest)
fig, ax = plt.subplots(figsize=(10, 6))
rf_model = results['Random Forest']['model']
importances = pd.Series(rf_model.feature_importances_, index=feature_cols)
importances.sort_values().plot(kind='barh', ax=ax, color='steelblue')
ax.set_title('Feature Importance - Random Forest', fontsize=13)
ax.set_xlabel('Importance Score')
plt.tight_layout()
plt.savefig(os.path.join(PROCESSED, "plot_feature_importance.png"), dpi=150)
plt.show()
print("  Saved: plot_feature_importance.png")

# Chart 4: Classification report for best model
print(f"\n  Classification Report - {best_model_name}:")
print(classification_report(y_test, results[best_model_name]['y_pred'],
                             target_names=label_names))

print("\n" + "=" * 60)
print("Model training complete.")
print(f"Best model: {best_model_name}")
print(f"Saved to: Models/best_model.pkl")
print("=" * 60)
print("\n*** SCREENSHOT THIS TERMINAL OUTPUT FOR YOUR REPORT ***")
print("*** SCREENSHOT ALL 3 CHARTS FOR YOUR REPORT ***")