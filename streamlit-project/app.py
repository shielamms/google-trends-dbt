import datetime
import pandas as pd
import streamlit as st
from google.oauth2 import service_account
from google.cloud import bigquery

credentials = service_account.Credentials.from_service_account_info(
    st.secrets["my_gcp_service_creds"]
)
client = bigquery.Client(credentials=credentials)

project = st.secrets["gcp_project"]
dataset = st.secrets["bq_dataset"]
table = st.secrets["bq_table"]


def build_query(country=None,
                start_date=None,
                end_date=None):
    query = (
        f'''
        SELECT *
        FROM `{project}.{dataset}.{table}`

        '''
    )

    conditions = []
    if country:
        conditions.append(
            f'''
            country_code = "{country}"

            '''
        )
    if start_date:
        conditions.append(
            f'''
            week_start_date >= "{ start_date }"

            '''
        )
    if end_date:
        conditions.append(
            f'''
            week_start_date <= "{ end_date }"
            '''
        )

    if len(conditions) > 1:
        query += 'WHERE ' + ' AND '.join(conditions)
    elif len(conditions) == 1:
        query += 'WHERE ' + conditions[0]
    return query

@st.experimental_memo(ttl=600)
def read_bq_trending_terms(country=None,
                           start_date=None,
                           end_date=None):
    query = build_query(country, start_date, end_date)
    query_job = client.query(query)
    results = query_job.result()
    rows = [dict(row) for row in results]
    return rows


st.write('## Google Trends Keywords 2022')
# country = 'GB'
# start_date = '2022-09-01'
# end_date = '2022-09-20'

country = st.text_input('Country Code')
start_date = st.date_input(
    'From',
    value=datetime.date.today(),
    min_value=datetime.datetime.strptime('2022-01-01', '%Y-%M-%d'),
    max_value=datetime.date.today()
)
end_date = st.date_input(
    'To',
    value=datetime.date.today(),
    min_value=datetime.datetime.strptime('2022-01-01', '%Y-%M-%d'),
    max_value=datetime.date.today()
)

results = read_bq_trending_terms(country, start_date, end_date)

st.write("Some results here...")

st.write(pd.DataFrame(results))