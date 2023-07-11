#!/usr/bin/env bash

if [ $# -gt 0 ]; then
  AIRFLOW_VERSION=$1
else
  AIRFLOW_VERSION=2.6.3
fi

# Rest of the script remains the same
PYTHON_VERSION="$(python3 --version | cut -d " " -f 2 | cut -d "." -f 1-2)"
CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_VERSION}.txt"

python3 -m pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"
