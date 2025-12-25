from dagster_airbyte import AirbyteCloudWorkspace, build_airbyte_assets_definitions, DagsterAirbyteTranslator, AirbyteConnectionTableProps
from dagster import EnvVar, AutomationCondition, AssetSpec, AssetKey
# https://docs.dagster.io/api/libraries/dagster-airbyte


class CustomDagsterAirbyteTranslator(DagsterAirbyteTranslator):
    def get_asset_spec(self, props: AirbyteConnectionTableProps) -> AssetSpec:
        default_spec = super().get_asset_spec(props)
        return default_spec.replace_attributes(
            key=AssetKey(["raw", props.table_name]),
            group_name="airbyte_assets",
            # automation_condition=AutomationCondition.on_cron(cron_schedule="* * * * *")
        )

airbyte_workspace = AirbyteCloudWorkspace(
    workspace_id=EnvVar("AIRBYTE_CLOUD_WORKSPACE_ID"),
    client_id=EnvVar("AIRBYTE_CLOUD_CLIENT_ID"),
    client_secret=EnvVar("AIRBYTE_CLOUD_CLIENT_SECRET")
)

# Load all assets from your Airbyte workspace
airbyte_assets = build_airbyte_assets_definitions(
    workspace=airbyte_workspace,
    connection_selector_fn=lambda connection: connection.name in ["EEH CSV → Snowflake"],
    dagster_airbyte_translator=CustomDagsterAirbyteTranslator()
)