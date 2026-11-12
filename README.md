# FloodGuard Malaysia: Flood Risk Prediction and Disaster Preparedness Platform

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

1. **Data Preparation**: filtered two generated datasets (21,978 records each, 16 states, 2010 to 2026) to the four target states and merged them by date, state and district: 7,128 records, 18 columns.
2. **Feature Engineering**: created five features: monsoon flag, 7-day rolling rainfall, water level category, alert level code and season code.
3. **Risk Labelling**: assigned High, Medium or Low risk with a composite score of rainfall, water level, alert level and monsoon season.
4. **Class Balancing**: balanced the three risk classes with SMOTE (Medium 75.1%, High 23.0%, Low 1.9% before balancing).
5. **Model Training**: trained Random Forest, XGBoost and Logistic Regression on an 80/20 stratified split, then tuned Random Forest with a 3-fold grid search.
6. **Deployment**: served the tuned model through a Flask REST API with `/health` and `/predict` endpoints and input validation.
7. **Mobile App**: built the Flutter Android app with Firebase, OpenStreetMap, OpenWeatherMap and a Google Gemini chatbot.
8. **Dashboard**: built a two-page Power BI dashboard with a district risk map, rainfall trends and high-risk district tables.
9. **Testing**: tested the full system in fifteen sections against the running app.

## What's in this repo

| File / Folder | Description |
| --- | --- |
| `preprocessing.py` | Loads, filters and merges the raw datasets, builds the features and labels, and applies SMOTE. |
| `model_training.py` | Trains and compares Random Forest, XGBoost and Logistic Regression. |
| `finalize_model.py` | Tunes the Random Forest with a grid search. |
| `edge_case_testing.py` | Tests the tuned model with extreme and invalid inputs. |
| `export_final_model.py` | Exports the final model and writes the model card. |
| `API/app.py` | Flask REST API that loads the final model and serves predictions. |
| `floodguard_app/` | Flutter source code for the Android app (`lib/`, `android/`, `pubspec.yaml`). |
| `Dashboard/` | Power BI dashboard file (`.pbix`) and its colour theme. |
| `Data/Raw/` | Generated rainfall, river and evacuation centre datasets, plus the flood datasets read by the pipeline. |
| `Data/Processed/` | Merged data, training data, model card and result charts. |
| `Models/` | Final Random Forest model (`.pkl`) and edge case results. |
| `Reports/Photo/` | Charts used in the dissertation. |
| `requirements.txt` | Python dependencies for the pipeline and the API. |

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

## Data sources

- The rainfall, river and evacuation centre datasets are synthetic. I generated them to follow Malaysian rainfall and station patterns.
- `malaysia_flood_master.csv`, `flood.csv` and `_MalaysiaFloodDataset_MalaysiaFloodDataset.csv` are public Kaggle flood datasets, included for reproducibility. Download the originals from Kaggle by searching these file names.

## Result charts

![Model comparison](Reports/Photo/Model%20Performance%20Comparison.png)
![Confusion matrix](Reports/Photo/Confusion%20Matrix%20-%20Random%20Forest.png)
![Feature importance](Reports/Photo/Feature%20Importance%20-%20Random%20Forest.png)

## How to run

**Machine learning pipeline and Flask API**

1. Install the dependencies:

   ```
   pip install -r requirements.txt
   ```

2. Run the pipeline in order:

   ```
   python preprocessing.py
   python model_training.py
   python finalize_model.py
   python edge_case_testing.py
   python export_final_model.py
   ```

3. Start the API:

   ```
   python API/app.py
   ```

4. Check `http://localhost:5000/health`, then send a POST request to `/predict`.

**Mobile app**

API keys and Firebase config are not included in this repository.

1. Create a Firebase project and run `flutterfire configure` inside `floodguard_app/`. This creates `lib/firebase_options.dart` and `android/app/google-services.json`. A template is in `lib/firebase_options.example.dart`.
2. Get your own Google Gemini and OpenWeatherMap API keys.
3. Install the packages and run the app with both keys:

   ```
   cd floodguard_app
   flutter pub get
   flutter run --dart-define=GEMINI_API_KEY=your_key --dart-define=OPENWEATHER_API_KEY=your_key
   ```

Only the Android platform folder is included. Run `flutter create .` inside `floodguard_app/` to add other platforms.

**Dashboard**

Open `Dashboard/FloodGuard Dashboard.pbix` with Power BI Desktop.

## Tools

Python (Pandas, NumPy, scikit-learn, imbalanced-learn, XGBoost), Flask, Flutter and Dart, Firebase (Firestore, Authentication), OpenStreetMap, OpenWeatherMap API, Google Gemini API, Power BI

## Author

Muhammad Haziq Akmal Bin Hasnol. Supervisor: Ts. Dr. Noureen Talpur.
