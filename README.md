# Retail Sales Forecasting Using Customer Purchase Behavior

A data mining project that analyzes a retail dataset of 1 million transactions and 78 attributes to identify customer purchasing patterns and sales drivers. It builds Random Forest models to predict customer churn and forecast total sales.

## Dataset

`retail_data.csv` is not included in this repository, it's 518 MB, well over GitHub's 100 MB file limit. Download it from Google Drive: https://drive.google.com/file/d/1hHJ33qKHkN9H4a3zoHxdaGdHeWoBcrlB/view?usp=sharing. Place it in this folder before running the script, or update `CSV_PATH` in `generate_charts.py` to point to your local copy.

The dataset contains 1,000,000 rows and 78 columns, covering customer demographics, transaction history, purchasing behavior, loyalty metrics, product details, promotions, and store information.

## What the script does

`generate_charts.py`:

1. Loads the full dataset and reports row count, duplicates, and missing values.
2. Samples 150,000 rows for model training (configurable via `SAMPLE_N`).
3. Prepares features from customer demographics, transaction history, purchasing behavior, loyalty metrics, and customer value indicators.
4. Trains a Random Forest Classifier to predict customer churn.
5. Trains a Random Forest Regressor to forecast total sales.
6. Evaluates the classifier with accuracy, precision, recall, F1-score, and a confusion matrix.
7. Evaluates the regressor with MAE, RMSE, and R-squared.
8. Saves all results to `results.json` and saves charts (confusion matrix, feature importance, correlation heat map, and more) to the `figs/` folder.

## How to run

1. Install the dependencies:

   ```
   pip install -r requirements.txt
   ```

2. Download `retail_data.csv` and place it in this folder, or update the `CSV_PATH` variable at the top of `generate_charts.py`.

3. Run the script:

   ```
   python generate_charts.py
   ```

4. Check `results.json` for the metrics and the `figs/` folder for the charts.

## Results summary

- Churn model: see `results.json` for accuracy, precision, recall, F1-score, and top features.
- Sales regression model: see `results.json` for MAE, RMSE, and R-squared.

## Tech stack

Python, Pandas, NumPy, scikit-learn, Matplotlib
