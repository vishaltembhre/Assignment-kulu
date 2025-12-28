FROM python:3.10-slim

WORKDIR /dbt

# Install system dependencies
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Install dbt-duckdb
RUN pip install dbt-duckdb

# Copy project files
COPY . .

# Default command
CMD ["dbt", "run", "--profiles-dir", "."]
