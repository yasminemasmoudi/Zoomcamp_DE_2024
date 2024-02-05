import pyarrow as pa
import pyarrow.parquet as pq
import os 

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = "/home/src/de-zoomcamp-413000-8d28a08d1b5e.json"  #path in mage

bucket_name = 'mage_yasmine_masmoudi_de_2024'

project_id = 'de-zoomcamp-413000'

table_name = "green_taxi_data"

root_path = f'{bucket_name}/{table_name}'


@data_exporter
def export_data(data, *args, **kwargs):
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['lpep_pickup_date'],
        filesystem=gcs
    )
