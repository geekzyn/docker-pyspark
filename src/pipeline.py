from pyspark.sql import SparkSession
from datetime import datetime
from pyspark.sql import Row

spark = SparkSession.builder.getOrCreate()

df = spark.createDataFrame([
    Row(id=1, name='John', start_date=datetime(2000, 1, 1, 12, 0)),
    Row(id=2, name='Helga', start_date=datetime(2000, 1, 2, 12, 0)),
    Row(id=3, name='James', start_date=datetime(2000, 1, 3, 12, 0))
])

df.show()
