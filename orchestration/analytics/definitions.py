from dagster import Definitions

from analytics.assets.airbyte import airbyte_assets, airbyte_workspace
from analytics.assets.dbt import dbt_warehouse, dbt_warehouse_resource
from analytics.assets.preprocess import upload_to_s3

defs = Definitions(
    assets=[upload_to_s3, *airbyte_assets, dbt_warehouse],
    # jobs=[run_alpaca_etl],
    # schedules=[alpaca_etl_schedule],
    resources={
        "airbyte": airbyte_workspace,
        "dbt_warehouse_resource": dbt_warehouse_resource,
    },
)
