from pathlib import Path

from dagster import AssetExecutionContext, AutomationCondition, EnvVar
from dagster_dbt import DagsterDbtTranslator, DbtCliResource, dbt_assets

# construct relative path to the dbt project directory
# dbt_project_dir = Path(__file__).joinpath("..","..","..", "..","..","transformation", "dw").resolve() # current_file_path -> navigate to dbt_project folder
# dbt_warehouse_resource: DbtCliResource = DbtCliResource(project_dir=os.fspath(dbt_project_dir))

# Set dbt target


BRANCH = EnvVar("GIT_BRANCH", "local")      # injected by CI/CD
DBT_TARGET = "prod" if BRANCH == "main" else "dev"

dbt_warehouse_resource: DbtCliResource = DbtCliResource(project_dir="transformation/dw", target=DBT_TARGET)

# Install dbt packages
deps_res = dbt_warehouse_resource.cli(["deps"], target_path=Path("target")).wait()

# generate manifest.json and retrieve path to manifest json
dbt_manifest_path = (
    dbt_warehouse_resource.cli(["--quiet", "parse"], target_path=Path("target"))
    .wait()
    .target_path.joinpath("manifest.json")
)


class CustomDagsterDbtTranslator(DagsterDbtTranslator):
    def get_automation_condition(self, dbt_resource_props):
        return AutomationCondition.eager()


# load manifest to produce asset defintion
@dbt_assets(
    manifest=dbt_manifest_path, dagster_dbt_translator=CustomDagsterDbtTranslator()
)
def dbt_warehouse(
    context: AssetExecutionContext, dbt_warehouse_resource: DbtCliResource
):
    # Define how dagster will run each dbt model
    yield from dbt_warehouse_resource.cli(["run"], context=context).stream()
