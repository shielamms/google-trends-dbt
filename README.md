# End-to-end ELT pipeline of Google Trends data with dbt and BigQuery

## Setup
This project was written with dbt-bigquery v1.2.0 on Python 3.7.9. To set up this project in your local environment, it is recommended that you use a virtual environment to install the required dbt libraries.

```
pyenv install 3.7.9
pyenv local 3.7.9
virtualenv venv
source venv/bin/activate
pip install -r requirements.txt
```

### dbt profile

You need to create a `profiles.yml` in your `.dbt` directory to let dbt know where to generate the materialised views for this project. Since this project is specifically for running dbt on BigQuery, you first need a Google Cloud account, where you then need to create a service credential to be able to access BigQuery from dbt.

The `profiles.yml` looks something like this:

```yaml
 shiela:
   outputs:
     dev:
       type: bigquery
       method: service-account
       project: gcp-practice
       dataset: shiela_practice_dev
       location: US
       threads: 2
       timeout_seconds: 300
       keyfile_json: your_home_dir/location/of/file/your_service_credentials_filename.json
 ```
