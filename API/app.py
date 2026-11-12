"""
FloodGuard Malaysia - Flask REST API
Phase 6: Serves the trained model as a prediction endpoint
for the Flutter mobile app.
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import pandas as pd
import os

# ── SETUP ──────────────────────────────────────────────────────────────────
app = Flask(__name__)
CORS(app)

MODEL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "Models", "floodguard_final_model.pkl")
model = joblib.load(MODEL_PATH)

FEATURE_COLS = [
    'Year', 'Month', 'Is_Monsoon', 'Rainfall_mm', 'Rainfall_7day_rolling',
    'Temperature_C', 'Humidity_pct', 'Wind_Speed_kmh', 'Cloud_Cover_pct',
    'Water_Level_m', 'Water_Discharge_m3s', 'Alert_Level_Encoded',
    'Season_Encoded'
]

LABEL_NAMES = {0: 'High', 1: 'Low', 2: 'Medium'}

print(f"Model loaded from: {MODEL_PATH}")
print(f"Expected input features: {FEATURE_COLS}")


# ── VALIDATION ─────────────────────────────────────────────────────────────
def validate_input(data):
    """
    Checks the incoming request for missing fields and invalid
    sensor readings. This closes the gap found in Phase 5 edge case
    testing, where all-zero sensor input got a confident prediction
    instead of being flagged as invalid.
    """
    errors = []

    missing = [f for f in FEATURE_COLS if f not in data]
    if missing:
        errors.append(f"Missing fields: {missing}")
        return errors

    # Flag all sensor readings being exactly zero as likely invalid
    sensor_fields = ['Rainfall_mm', 'Temperature_C', 'Humidity_pct',
                      'Wind_Speed_kmh', 'Water_Level_m', 'Water_Discharge_m3s']
    if all(data.get(f, 0) == 0 for f in sensor_fields):
        errors.append(
            "All sensor readings are zero. This looks like a sensor "
            "fault or missing data, not a real reading. Prediction blocked."
        )

    # Basic range checks
    if not (1 <= data.get('Month', 0) <= 12):
        errors.append("Month must be between 1 and 12.")
    if data.get('Rainfall_mm', 0) < 0:
        errors.append("Rainfall_mm cannot be negative.")
    if data.get('Water_Level_m', 0) < 0:
        errors.append("Water_Level_m cannot be negative.")
    if not (-10 <= data.get('Temperature_C', 0) <= 55):
        errors.append("Temperature_C must be between -10 and 55.")
    if not (0 <= data.get('Humidity_pct', 0) <= 100):
        errors.append("Humidity_pct must be between 0 and 100.")
    if not (0 <= data.get('Wind_Speed_kmh', 0) <= 250):
        errors.append("Wind_Speed_kmh must be between 0 and 250.")
    if not (0 <= data.get('Cloud_Cover_pct', 0) <= 100):
        errors.append("Cloud_Cover_pct must be between 0 and 100.")

    return errors


# ── ROUTES ─────────────────────────────────────────────────────────────────
@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "service": "FloodGuard Malaysia API",
        "status": "running",
        "endpoints": {
            "/predict": "POST - send sensor readings, get flood risk prediction",
            "/health": "GET - check if API and model are working"
        }
    })


@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "model_loaded": model is not None})


@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()

    if data is None:
        return jsonify({"error": "No JSON data received"}), 400

    # Validate
    errors = validate_input(data)
    if errors:
        return jsonify({"error": "Invalid input", "details": errors}), 400

    # Build feature row in the correct order
    row = pd.DataFrame([{f: data[f] for f in FEATURE_COLS}])

    # Predict
    pred = model.predict(row)[0]
    proba = model.predict_proba(row)[0]

    response = {
        "flood_risk": LABEL_NAMES[pred],
        "confidence": {
            "High": round(float(proba[0]), 4),
            "Low": round(float(proba[1]), 4),
            "Medium": round(float(proba[2]), 4)
        }
    }

    return jsonify(response)


# ── RUN ────────────────────────────────────────────────────────────────────
if __name__ == '__main__':
    print("\nStarting FloodGuard Malaysia API...")
    print("Test it at: http://127.0.0.1:5000")
    app.run(debug=True, host='0.0.0.0', port=5000, use_reloader=False)