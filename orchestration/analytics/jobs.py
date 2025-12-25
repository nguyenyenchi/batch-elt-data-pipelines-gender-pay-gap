
from dagster import job
from analytics.ops import get_data, print_data

@job
def my_job():
    output = get_data()
    print_data(output)