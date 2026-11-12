"""
FloodGuard Malaysia - Phase 5, Step 1: Hyperparameter Tuning
Finds the best Random Forest settings using GridSearchCV.
"""

import pandas as pd
import numpy as np
import os
import joblib
import warnings
warnings.filterwarnings('ignore')

from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score

# ── PATHS ──────────────────────────────────────────────────────────────────
PROCESSED = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Data", "Processed")
MODELS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Models")
os.makedirs(MODELS, exist_ok=True)

print("=" * 60)
print("Phase 5, Step 1: Hyperparameter Tuning")
print("=" * 60)

# ── STEP 1: LOAD DATA ──────────────────────────────────────────────────────
print("\n[1/3] Loading master_training.csv...")

df = pd.read_csv(os.path.join(PROCESSED, "master_training.csv"))

feature_cols = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

X = df[feature_cols]
y = df['Flood_Risk_Encoded']

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"  Training set: {X_train.shape}")
print(f"  Test set:     {X_test.shape}")

# ── STEP 2: GRID SEARCH ────────────────────────────────────────────────────
print("\n[2/3] Running GridSearchCV (this may take a few minutes)...")

param_grid = {
    'n_estimators': [100, 200, 300],
    'max_depth': [10, 20, None],
    'min_samples_split': [2, 5],
    'min_samples_leaf': [1, 2]
}

rf = RandomForestClassifier(random_state=42, n_jobs=-1)

grid_search = GridSearchCV(
    estimator=rf,
    param_grid=param_grid,
    cv=3,
    scoring='f1_weighted',
    n_jobs=-1,
    verbose=1
)

grid_search.fit(X_train, y_train)

print(f"\n  Best parameters: {grid_search.best_params_}")
print(f"  Best CV F1-score: {grid_search.best_score_:.4f}")

# ── STEP 3: EVALUATE TUNED MODEL ───────────────────────────────────────────
print("\n[3/3] Evaluating tuned model on test set...")

best_rf = grid_search.best_estimator_
y_pred = best_rf.predict(X_test)

acc = accuracy_score(y_test, y_pred)
f1 = f1_score(y_test, y_pred, average='weighted')

print(f"  Tuned model accuracy: {acc:.4f}")
print(f"  Tuned model F1-score: {f1:.4f}")

# Save the tuned model (temporary, Step 3 will finalize it)
joblib.dump(best_rf, os.path.join(MODELS, "tuned_model.pkl"))
print(f"\n  Saved: tuned_model.pkl")

print("\n" + "=" * 60)
print("Step 1 complete.")
print("=" * 60)
print("\n*** SCREENSHOT THIS TERMINAL OUTPUT FOR YOUR REPORT ***")
