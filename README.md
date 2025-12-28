# Gender Pay Gap Batch Data Engineering Pipeline

This repository contains a Batch Data Engineering Pipeline that delivers an end-to-end workflow—from raw data ingestion to analytics-ready insights. It processes data from the Australian Bureau of Statistics (ABS), applies transformations, and produces aggregated datasets for business intelligence, focusing on gender pay gap trends across occupations between 2016 and 2023 in Australia.

The ABS Employee Earnings and Hours (EEH) dataset does not provide occupation-level cuts. This pipeline bridges that gap by ingesting and transforming EEH and related labour data to enable deeper insights through a visual dashboard.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Solution Architecture](#solution-architecture)
3. [Pipeline Breakdown](#pipeline-breakdown)
4. [Future Improvements](#future-improvements)


## 1. Project Structure

- `Main branch`: Project overview and architecture
- `integration/`: End-to-end batch pipeline integration [integration](/integration/README.md)
- `orchestration/`: Scheduling and orchestration [orchestration](/orchestration/README.md)
- `transformation/`: dbt project for data modeling [transformation](/transformation/README.md)
- `visualisation/`: BI dashboards for analytics [visualisation](/visualisation/README.md)
- `Docs/`: Architecture diagrams and supporting visuals


## 2. Solution Architecture
![Pipeline Architecture Diagram](Docs\images\architecture.png)


Data Sources:

- **Data Sources**: 2 data sources from ABS:
    - [Employee Earnings and Hours, Australia](https://www.abs.gov.au/statistics/labour/earnings-and-working-conditions/employee-earnings-and-hours-australia/latest-release). Year: 2016, 2018, 2021, 2023. Includes earnings and hours statistics.
    - [National Occupation Trend - August 2025](https://www.jobsandskills.gov.au/data/labour-force-trending). Sourced from ABS's [Labour Force, Australia, Detailed](https://www.abs.gov.au/statistics/labour/employment-and-unemployment/labour-force-australia-detailed/latest-release). Quarterly employment data at different levels of occupations.

- **S3 Buckets**: Store preprocessed CSV files from ABS Excel sources
- **Airbyte Cloud**: Custom connectors for incremental ingestion from S3 to Snowflake
- **Snowflake**: Cloud data warehouse for staging and marts
- **dbt**: Data transformation and modeling
- **Dagster+**: Cloud orchestration tool for data ingestion, Airbyte sync, and dbt runs
- **Power BI**: Dashboards showing gender pay gap metrics by occupation and year
- **CI/CD (GitHub Actions)**: Automates linting, testing and Dagster Cloud deployment on PR merges


## 3. Pipeline Breakdown

### Development Branch

- Data Collection:
    - Historical data in Excel formats are downloaded from ABS
    - Light preprocessing using Python script to convert the Excel files to csv files for storage in S3 buckets and ingestion in Snowflake
- Data Ingestion:
    - Since each file contains historical data and we know that the source data won't change (only use past data) goind forward, the sync mode is set to incremental append in airbyte i.e. when a new file comes in, it will contains only new data, so it will be appended to the raw tables in Snowflake. What are some caveats with this?
- Data Storage and Transformation:
    - Using dbt, data is transformed from raw -> staging -> marts models ready for consumption for dashboard and analytics
- Analytics & Visualisation: Power BI dashboards for earnings and gender pay gap trends
- Automation & Monitoring: Dagster schedules and CI/CD integration


## 4. Future Improvements

- Automate dashboard refreshes by adding Power BI as an asset in Dagster Cloud
- Advanced analytics (e.g., machine learning models)
- Enhanced data quality checks