# FloodGuard Malaysia — Flood Risk Prediction and Disaster Preparedness Platform

Final Year Project at Universiti Teknologi PETRONAS (Bachelor of Information Technology, Big Data Analytics). FloodGuard Malaysia predicts district-level flood risk with machine learning, delivers it to citizens through an Android mobile app, and gives agencies a Power BI geospatial dashboard.

## Objectives

- Develop a machine learning model for district-level flood risk classification using rainfall, river level and flood data for Kelantan, Terengganu, Selangor and Johor.
- Develop an integrated flood preparedness platform: a GPS-enabled mobile app with alerts and AI assistance, and a Power BI geospatial dashboard.
- Evaluate the platform by comparing Random Forest, XGBoost and Logistic Regression, and by structured system testing.

## Scope

- Four Malaysian states: Kelantan, Terengganu, Selangor and Johor.
- Three classifiers: Random Forest, XGBoost and Logistic Regression.
- Android mobile app built with Flutter: nine features in English, Bahasa Malaysia, Mandarin and Tamil.
- Power BI dashboard for agency analysts (JPS and NADMA).
- Synthetic rainfall and river hydrology datasets that follow Malaysian rainfall patterns. Real JPS and MetMalaysia records are not included.

## Methodology

The project follows the CRISP-DM methodology.

1. **Data Preparation** — filtered two generated datasets (21,978 records each, 16 states, 2010 to 2026) to the four target states and merged them by date, state and district: 7,128 records, 18 columns.
2. **Feature Engineering** — created five features: monsoon flag, 7-day rolling rainfall, water level category, alert level code and season code.
3. **Risk Labelling** — assigned High, Medium or Low risk with a composite score of rainfall, water level, alert level and monsoon season.
4. **Class Balancing** — balanced the three risk classes with SMOTE (Medium 75.1%, High 23.0%, Low 1.9% before balancing).
5. **Model Training** — trained Random Forest, XGBoost and Logistic Regression on an 80/20 stratified split, then tuned Random Forest with a 3-fold grid search.
6. **Deployment** — served the tuned model through a Flask REST API with `/health` and `/predict` endpoints and input validation.
7. **Mobile App** — built the Flutter Android app with Firebase, OpenStreetMap, OpenWeatherMap and a Google Gemini chatbot.
8. **Dashboard** — built a two-page Power BI dashboard with a district risk map, rainfall trends and high-risk district tables.
9. **Testing** — tested the full system in fifteen sections against the running app.

## What's in this repo

| File / Folder | Description |
| --- | --- |
| `ml/` | Data preprocessing and model training scripts or notebooks. |
| `api/` | Flask REST API that loads the trained model and serves predictions. |
| `mobile_app/` | Flutter source code for the Android app. |
| `dashboard/` | Power BI file (`.pbix`) for the geospatial dashboard. |
| `data/` | Generated rainfall and river datasets, and the merged training data. |
| `model_card.txt` | Features, training data, performance and known limits of the final model. |
| `requirements.txt` | Python dependencies for the model and the API. |

## Key results

| Model | Accuracy | Precision | Recall | F1-score |
| --- | --- | --- | --- | --- |
| Random Forest (baseline) | 99.41% | 99.41% | 99.41% | 99.41% |
| XGBoost | 99.41% | 99.41% | 99.41% | 99.41% |
| Logistic Regression | 89.41% | 89.31% | 89.41% | 89.29% |
| Random Forest (tuned) | 99.38% | n/a | n/a | 99.38% |

- Random Forest was selected: equal accuracy to XGBoost, with clearer feature importance.
- 19 of 3,210 test records were misclassified, all between neighbouring risk levels.
- Water level and rainfall are the two strongest predictors.
- The mobile app lists 346 evacuation centres sorted by distance and supports four languages.
- 14 of 15 system test sections passed. Five defects were found and fixed.

## Limitations

- The training data is synthetic. The model has not been tested on real JPS or MetMalaysia records, so the accuracy does not represent real-world flood prediction.
- Risk labels come from a scoring rule that uses the same inputs as the model.
- SMOTE was applied before the train and test split, so the test set includes synthetic records.
- The app uses a water condition selected by the user, since no public river sensor API exists.

## How to run

**Flask API**

1. Install the dependencies:

   ```
   pip install -r requirements.txt
   ```

2. Start the API:

   ```
   python api/app.py
   ```

3. Check `http://localhost:5000/health`, then send a POST request to `/predict`.

**Mobile app**

1. Add your own API keys for OpenWeatherMap, Google Gemini and Firebase. Keys are not included in this repository.
2. Install the packages and run the app:

   ```
   flutter pub get
   flutter run
   ```

**Dashboard**

Open the `.pbix` file in `dashboard/` with Power BI Desktop.

## Tools

Python (Pandas, NumPy, scikit-learn, imbalanced-learn, XGBoost), Flask, Flutter and Dart, Firebase (Firestore, Authentication), OpenStreetMap, OpenWeatherMap API, Google Gemini API, Power BI
