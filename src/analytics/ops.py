from dagster import op

@op
def get_data():
    return ["hello", "world"]

@op
def print_data(data):
    for row in data:
        print(row)