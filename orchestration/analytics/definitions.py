

from dagster import Definitions
# from analytics.assets.dbt import dbt_warehouse, dbt_warehouse_ressource
from analytics.assets.airbyte import airbyte_assets, airbyte_workspace

# defs = Definitions(
#     assets=[*airbyte_assets, dbt_warehouse],
#     # jobs=[run_alpaca_etl],
#     # schedules=[alpaca_etl_schedule],
#     resources={
#         "airbyte": airbyte_workspace,
#         "dbt_warehouse_resource": dbt_warehouse_ressource
#     }
# )


defs = Definitions(
    assets=[*airbyte_assets],
    # jobs=[run_alpaca_etl],
    # schedules=[alpaca_etl_schedule],
    resources={
        "airbyte": airbyte_workspace
    }
)