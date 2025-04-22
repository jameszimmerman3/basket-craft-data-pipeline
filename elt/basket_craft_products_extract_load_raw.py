"""
1. import necessary libraries
2. Load source Mysql and destination postgres connection dedatils
3. build connection strings and create database engines
4. read products table in mysql and then load into dataframe
5. write df to products table in postgres
"""
#%%
import pandas as pd
from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

#%%
#load environment vairables from .env file
load_dotenv()

os.environ['MYSQL_USER']
# %%
#Mysql db connection details
mysql_user = os.environ['MYSQL_USER']
mysql_password = os.environ['MYSQL_PASSWORD']
mysql_host = os.environ['MYSQL_HOST']
mysql_db = os.environ['MYSQL_DB']

# postgres database connection details
pg_user = os.environ['PG_USER']
pg_password = os.environ['PG_PASSWORD']
pg_host = os.environ['PG_HOST']
pg_db = os.environ['PG_DB']
# %%
# build connection strings
mysql_conn_str = f'mysql+pymysql://{mysql_user}:{mysql_password}@{mysql_host}/{mysql_db}'
pg_conn_str = f'postgresql+psycopg2://{pg_user}:{pg_password}@{pg_host}/{pg_db}'

# %%
# create database engines
mysql_engine = create_engine(mysql_conn_str)
pg_engine = create_engine(pg_conn_str)
# %%
# read products table from mysql
df = pd.read_sql('SELECT * FROM products', mysql_engine)
# %%
# df
# %%
# write df to products table in pg 
df.to_sql('products', pg_engine, schema='raw', if_exists='replace', index=False)
# %%
print(f'{len(df)} records loaded into Postgres products table.')
# %%
