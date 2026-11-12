"""
FloodGuard Malaysia - Phase 5, Step 2: Edge Case Testing
Tests the tuned model against extreme and unusual scenarios.
"""

import pandas as pd
import numpy as np
import os
import joblib
import warnings
warnings.filterwarnings('ignore')

# ── PATHS ──────────────────────────────────────────────────────────────────
MODELS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Models")

print("=" * 60)
print("Phase 5, Step 2: Edge Case Testing")
print("=" * 60)

# ── LOAD MODEL ─────────────────────────────────────────────────────────────
print("\n[1/2] Loading tuned model...")
model = joblib.load(os.path.join(MODELS, "tuned_model.pkl"))
print("  Model loaded.")

feature_cols = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

label_names = {0: 'High', 1: 'Low', 2: 'Medium'}

# ── EDGE CASES ─────────────────────────────────────────────────────────────
print("\n[2/2] Testing edge cases...\n")

edge_cases = {
    "Extreme rainfall + high water level (expect: High)": {
        'Year': 2026, 'Month': 12, 'Is_Monsoon': 1, 'Rainfall_mm': 250,
        'Rainfall_7day_rolling': 180, 'Temperature_C': 26, 'Humidity_pct': 95,
        'Wind_Speed_kmh': 40, 'Cloud_Cover_pct': 100, 'Water_Level_m': 7.5,
        'Water_Discharge_m3s': 500, 'Alert_Level_Encoded': 3, 'Season_Encoded': 2
    },
    "Zero rainfall + normal water level (expect: Low)": {
        'Year': 2026, 'Month': 6, 'Is_Monsoon': 0, 'Rainfall_mm': 0,
        'Rainfall_7day_rolling': 0, 'Temperature_C': 33, 'Humidity_pct': 60,
        'Wind_Speed_kmh': 10, 'Cloud_Cover_pct': 10, 'Water_Level_m': 0.8,
        'Water_Discharge_m3s': 50, 'Alert_Level_Encoded': 0, 'Season_Encoded': 0
    },
    "Moderate rainfall + rising water level (expect: Medium)": {
        'Year': 2026, 'Month': 11, 'Is_Monsoon': 1, 'Rainfall_mm': 70,
        'Rainfall_7day_rolling': 55, 'Temperature_C': 27, 'Humidity_pct': 85,
        'Wind_Speed_kmh': 25, 'Cloud_Cover_pct': 70, 'Water_Level_m': 2.5,
        'Water_Discharge_m3s': 150, 'Alert_Level_Encoded': 1, 'Season_Encoded': 2
    },
    "Missing/zero sensor readings (stress test)": {
        'Year': 2026, 'Month': 1, 'Is_Monsoon': 1, 'Rainfall_mm': 0,
        'Rainfall_7day_rolling': 0, 'Temperature_C': 0, 'Humidity_pct': 0,
        'Wind_Speed_kmh': 0, 'Cloud_Cover_pct': 0, 'Water_Level_m': 0,
        'Water_Discharge_m3s': 0, 'Alert_Level_Encoded': 0, 'Season_Encoded': 0
    },
    "High rainfall but low water level (mismatch test)": {
        'Year': 2026, 'Month': 4, 'Is_Monsoon': 0, 'Rainfall_mm': 180,
        'Rainfall_7day_rolling': 120, 'Temperature_C': 28, 'Humidity_pct': 90,
        'Wind_Speed_kmh': 30, 'Cloud_Cover_pct': 90, 'Water_Level_m': 1.0,
        'Water_Discharge_m3s': 80, 'Alert_Level_Encoded': 0, 'Season_Encoded': 1
    },
}

results = []
for description, values in edge_cases.items():
    row = pd.DataFrame([values])[feature_cols]
    pred = model.predict(row)[0]
    proba = model.predict_proba(row)[0]
    print(f"  {description}")
    print(f"    -> Predicted: {label_names[pred]}")
    print(f"    -> Confidence: High={proba[0]:.2f}, Low={proba[1]:.2f}, Medium={proba[2]:.2f}\n")
    results.append({'Scenario': description, 'Prediction': label_names[pred]})

results_df = pd.DataFrame(results)
results_df.to_csv(os.path.join(MODELS, "edge_case_results.csv"), index=False)

print("=" * 60)
print("Step 2 complete. Edge case results saved.")
print("=" * 60)
print("\n*** SCREENSHOT THIS TERMINAL OUTPUT FOR YOUR REPORT ***")
