# Superstore Intelligence Dashboard

An interactive e-commerce business intelligence dashboard built with Streamlit and Plotly. It analyzes 9,983 transaction records across four years of sales data to surface trends in sales, profit, and discounting.

## Features

- KPI cards for sales, profit, and order volume
- Category and region filters with drill-down charts
- Monthly sales trend chart
- Profit margin heat map by region and category
- Parallel coordinate plot for multi-metric comparison
- State-level sales breakdown
- Adjustable display modes (Standard, Large Text, Simple View) for accessibility
- Project progress timeline

## Dataset

`superstore_dataset.csv` contains order-level e-commerce transactions, including order and ship dates, category, region, state, sales, discount, and profit.

## How to run

1. Clone this repository.
2. Install the dependencies:

   ```
   pip install -r requirements.txt
   ```

3. Run the app:

   ```
   streamlit run GroupProjectDV.py
   ```

4. Open the local URL Streamlit prints in your terminal (usually http://localhost:8501).

## Tech stack

Python, Streamlit, Pandas, Plotly

## Project poster

See `DV_Poster.pdf` for the project summary poster.
