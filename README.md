# ESG & EMCE Power BI Dashboards — Maxis Broadband Sdn Bhd

Student Industrial Project (internship) at Maxis Broadband Sdn Bhd. Two Power BI dashboards that turn scattered raw data into centralized, interactive insights: one for ESG (Environmental, Social, Governance) monitoring, and one for EMCE (network performance and customer experience).

## Objectives

- Develop an ESG dashboard for monitoring sustainability-related performance indicators.
- Develop an EMCE dashboard for analyzing mobile network performance and customer experience.
- Integrate multiple datasets into a centralized, interactive Power BI environment.
- Support data-driven decision-making through clear, effective visualizations.

## Scope

- Two dashboards built in Power BI: ESG and EMCE.
- Simulated datasets created in Microsoft Excel, due to data confidentiality constraints.
- Data transformation and modeling using Power Query and DAX.
- Integration with Microsoft Fabric and BigQuery for data storage and processing.

## Methodology

1. **Data Preparation** — created simulated datasets in Excel covering sustainability, network performance, and customer experience KPIs, organized into structured tables.
2. **Data Transformation** — cleaned and standardized the data with Power Query: consistent column names, formats, and units, with duplicates and missing values handled.
3. **Data Modeling** — built relationships between tables in the Power BI semantic model and created KPIs with DAX measures.
4. **Dashboard Development** — designed interactive dashboards with KPI cards, trend lines, bar charts, matrices, tables, maps, slicers, and filters, focused on usability for management and stakeholders.
5. **Validation** — verified data relationships and DAX measures, tested filtering and drill-throughs, and checked that dashboards represented the intended insights.

## What's in this repo

| File | Description |
|---|---|
| `University - Purpose 1.pbix` | The Power BI file with both the ESG and EMCE dashboards. Open with Power BI Desktop. |
| `UTP.xlsx` | EMCE dataset: network performance metrics by site (throughput, latency, CSSR, DCR, location, region). |
| `UTP 1.xlsx` | Supplementary dataset linked to the EMCE model by site ID. |
| `SIP REPORT.pdf` | Full written project report. |
| `SIP PRESENTATION.pptx` | Final presentation slide deck. |

## Key results

- The ESG dashboard tracks electricity usage, water consumption, and total cost, helping identify high-consumption areas and supporting a shift toward renewable energy.
- The EMCE dashboard monitors network performance metrics (CSSR, DCR, latency, throughput) in real time, helping teams identify low-performing regions quickly.
- Centralized dashboards reduced manual reporting effort and improved data accessibility and decision-making efficiency.

## Tools

Power BI (Power Query, DAX), Microsoft Excel, Microsoft Fabric, BigQuery
