"""
FloodGuard Malaysia - Phase 5, Step 3: Finalize Model & Model Card
Exports the tuned model as the official final model and writes
a model card document summarising it for the report.
"""

import pandas as pd
import numpy as np
import os
import joblib
import shutil
from datetime import date
import warnings
warnings.filterwarnings('ignore')

# ── PATHS ──────────────────────────────────────────────────────────────────
MODELS = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Models")
PROCESSED = os.path.join(os.path.dirname(os.path.abspath(__file__)), "Data", "Processed")

print("=" * 60)
print("Phase 5, Step 3: Finalize Model & Model Card")
print("=" * 60)

# ── STEP 1: EXPORT FINAL MODEL ─────────────────────────────────────────────
print("\n[1/2] Exporting final model...")

tuned_path = os.path.join(MODELS, "tuned_model.pkl")
final_path = os.path.join(MODELS, "floodguard_final_model.pkl")

shutil.copy(tuned_path, final_path)
print(f"  Saved: floodguard_final_model.pkl")
print("  This is the model your Flask API will load in Phase 6.")

# ── STEP 2: GENERATE MODEL CARD ────────────────────────────────────────────
print("\n[2/2] Generating model card...")

model = joblib.load(final_path)

# Pull edge case results if available
edge_case_path = os.path.join(MODELS, "edge_case_results.csv")
edge_cases_text = ""
if os.path.exists(edge_case_path):
    ec = pd.read_csv(edge_case_path)
    edge_cases_text = "\n".join(
        f"- {row['Scenario']} -> Predicted: {row['Prediction']}"
        for _, row in ec.iterrows()
    )

feature_cols = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

card = f"""FLOODGUARD MALAYSIA - MODEL CARD
Generated: {date.today().strftime('%d %B %Y')}

MODEL TYPE
Random Forest Classifier (tuned)
Parameters: {model.get_params()}

WHAT IT PREDICTS
Flood risk level for a given location and time: Low, Medium, or High.

INPUT FEATURES ({len(feature_cols)} total)
{chr(10).join(f'- {f}' for f in feature_cols)}

TRAINING DATA
- Source: FloodGuard synthetic rainfall and river hydrology datasets
- Coverage: Kelantan, Terengganu, Selangor, Johor
- Records: 7,128 real merged records, expanded to 16,047 after SMOTE balancing
- Note: Rainfall and river data are synthetic, generated to match real
  Malaysian station and district patterns. Real JPS and MetMalaysia data
  collection is planned for FYP 2 to retrain this model on live data.

PERFORMANCE (on held-out 20% test set)
- Accuracy: 99.38%
- F1-Score (weighted): 99.38%
- Compared against XGBoost (99.41%) and Logistic Regression (89.41%)

EDGE CASE TESTING RESULTS
{edge_cases_text}

KNOWN LIMITATIONS
1. The model has no built-in way to detect invalid or missing sensor
   input (all-zero readings were predicted as Medium risk instead of
   being flagged as invalid). This must be handled in the API layer.
2. High accuracy reflects patterns in synthetic training data. Real-world
   performance on live JPS/MetMalaysia data has not yet been validated.
3. Model is trained only on 4 states. It should not be used for
   predictions outside Kelantan, Terengganu, Selangor, or Johor.

INTENDED USE
This model is intended to power the FloodGuard Malaysia mobile app's
flood risk prediction feature via a Flask REST API (Phase 6).
"""

card_path = os.path.join(PROCESSED, "model_card.txt")
with open(card_path, "w", encoding="utf-8") as f:
    f.write(card)

print(f"  Saved: model_card.txt")
print("\n" + card)

print("=" * 60)
print("Phase 5 complete. Model is finalized and ready for the API.")
print("=" * 60)
print("\n*** SCREENSHOT THIS TERMINAL OUTPUT FOR YOUR REPORT ***")
print("*** COPY model_card.txt CONTENT INTO YOUR REPORT ***")
