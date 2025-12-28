# Gender Pay Gap Batch Data Engineering Pipeline

This repository contains a Batch Data Engineering Pipeline that delivers an end-to-end workflow—from raw data ingestion to analytics-ready insights. It processes data from the Australian Bureau of Statistics (ABS), applies transformations, and produces aggregated datasets for business intelligence, focusing on gender pay gap trends across occupations between 2016 and 2023 in Australia.

The ABS Employee Earnings and Hours (EEH) dataset does not provide occupation-level cuts. This pipeline bridges that gap by ingesting and transforming EEH and related labour data to enable deeper insights through a visual dashboard.

## Table of Contents

1. [Project Structure](#project-structure)
2. [Solution Architecture](#solution-architecture)
3. [Pipeline Breakdown](#pipeline-breakdown)
4. [CI/CD](#ci-cd)
5. [Future Improvements](#future-improvements)


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

- Data Collection

    - Historical datasets in Excel format are sourced from the ABS.
    - A lightweight Python preprocessing step converts these Excel files into CSV format for storage in **S3 buckets**, enabling downstream ingestion into **Snowflake**.

        ![S3](Docs\images\S3.png)


- Data Ingestion
    - Although the source data is historical, updates may occur in the future.
    - To handle this, Airbyte uses the Incremental Append + Deduped sync mode.
        - Example: The original file 2016.csv exists in S3, but a new file 2026_updated.csv might arrive later.
        - Airbyte appends new records and removes duplicates based on defined primary keys.
        ![airbyte](Docs\images\airbyte.png)

        ![airbyte-sync](Docs\images\airbyte-sync.png)

- Data Storage & Transformation
    - dbt transforms data through a layered approach: raw → staging → marts, producing analytics-ready models.
    - Separate schemas are maintained for each environment:
        - Dev: eeh_staging_dev, eeh_marts_dev
        - Prod: eeh_staging_prod, eeh_marts_prod

        ![tables](Docs\images\tables.png)

- Analytics & Visualization
    - Power BI dashboards connect to the Dev schema (for testing) and the deployed to Prod schema, leveraging fact and dimension tables to deliver insights on earnings and gender pay gap trends.

    ![dashboard](Docs\images\dashboard.png)
- Automation & Monitoring
    - See Section 4 for details on CI/CD orchestration.


## 4. CI/CD with Dagster Cloud and Github Actions

This section explains what happens when a new change e.g. a new file for year 2025 is added to local development and how it's triggered downstream processes.

#### Create a feature branch
Start from main and create a new branch for your changes
```
git checkout -b "new-branch"
```

#### Make the changes to codes and publish the branch
Commit the changes and publish the branch to the remote repository.
```
git add .
git commit -m "added new dbt models"
git push --set-upstream origin new-branch
```

#### Open a Pull Request (PR) to main
This triggers linting and validation checks (e.g., dbt linting, Python linting) via CI workflows.

#### Deploy the branch to Dagster Cloud Dev
The above PR also triggers Dagster Cloud to create or update a branch deployment in the Dev environment named "new-branch".
- Definitions are loaded for the branch.
- Then we manually Materialise assets to populate tables in the Dev schema in Snowflake.

#### Validate the Dev environment
Run tests and review dashboards to ensure data quality and correctness.
- If issues are found → fix the branch and redeploy to Dev.
- If everything looks good → proceed to merge the PR to main.

#### Merge the branch into main
This automatically triggers the Dagster Cloud Prod deployment workflow:
- Reloads Prod definitions.
- Materialises assets to populate tables in the Prod schema.

 ![workflow-runs](Docs\images\workflow-runs.png)

## 5. Future Improvements

- Automate dashboard refreshes by adding Power BI as an asset in Dagster Cloud
- Add advanced analytics (e.g., machine learning models)
- Enhanced CI/CD Workflows:
Expand automation to include:
    - Automated testing gates for dbt models and data quality checks before deployment.
    - Branch-based ephemeral environments for rapid feature validation.
    - Continuous deployment to Dev and Prod with rollback strategies for safer releases.
- Observability & Data Quality Monitoring
    - Add Dagster sensors and alerts for schema changes, failed materializations, and data drift detection.
- Scalability & Performance Optimisation
    - Implement Snowflake resource monitors, query tagging, and warehouse auto-scaling to optimize cost and performance.
- Documentation & Governance
    - Automate generation and hosting of dbt docs and lineage graphs for better transparency and compliance.