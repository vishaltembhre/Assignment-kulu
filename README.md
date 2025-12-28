# Dockerized Data Platform

This project implements a dockerized data analytics system that integrates user, onboarding, and transaction data from multiple CSV files into a lightweight DuckDB database. The data is transformed using dbt (data build tool) and exposed via a RESTful API.

## Project Structure

- **data/**: Contains the raw CSV files for users, onboarding, and transactions.
  - `users.csv`: User profile data including user IDs, names, emails, phone numbers, and creation dates.
  - `onboarding.csv`: Onboarding information for users including onboarding IDs, user IDs, roles, statuses, and onboarding dates.
  - `transactions.csv`: Transaction logs including transaction IDs, user IDs, amounts, and transaction dates.

- **dbt/**: Contains the dbt project files for data transformation.
  - `dbt_project.yml`: Configuration file for the dbt project.
  - `profiles.yml`: Connection configurations for dbt to connect to the database.
  - **models/**: Contains SQL transformation logic.
    - **staging/**: Staging models for initial data transformation.
      - `stg_users.sql`: SQL logic for staging users data.
      - `fct_onboarding.sql`: SQL logic for staging onboarding data.
      - `fct_transactions.sql`: SQL logic for staging transactions data.
    - **solution/analytics/**: Analytics models for generating insights.
      - `kyc_summary.sql`: SQL logic for generating a summary of KYC completions.
      - `top_users.sql`: SQL logic for identifying the top users by transaction amount.
      - `transactions_stats.sql`: SQL logic for calculating transaction statistics.
      - `kyc_vs_pending.sql`: SQL logic for comparing transaction behavior between KYC-completed and pending users.
  - **seeds/**: Seed data files for dbt.
    - `users.csv`: Seed data for users.
    - `onboarding.csv`: Seed data for onboarding.
    - `transactions.csv`: Seed data for transactions.

- **loader/**: Contains the loader service for loading CSV data into DuckDB.
  - `load_to_duckdb.py`: Python script for loading CSV data.
  - `Dockerfile`: Dockerfile for building the loader service.

- **api/**: Contains the API service for exposing analytics data.
  - `app.py`: Main entry point for the API.
  - `requirements.txt`: Python dependencies for the API.
  - `Dockerfile`: Dockerfile for building the API service.
  - **routes/**: Contains API route definitions.
    - `analytics.py`: API routes for exposing analytics data.
  - **tests/**: Contains unit tests for the API.
    - `test_api.py`: Unit tests for API endpoints.
  - **api-endpoints/**:
    Root: http://localhost:8000/
    KYC growth: http://localhost:8000/api/v1/kyc-growth
    Top users: http://localhost:8000/api/v1/top-users
    Transaction stats: http://localhost:8000/api/v1/transaction-stats
    Merchant analysis: http://localhost:8000/api/v1/merchant-analysis
    Interactive docs: http://localhost:8000/docs

- **infra/**: Contains infrastructure configuration files.
  - `docker-compose.yml`: Docker Compose configuration for orchestrating services.

- **scripts/**: Contains utility scripts.
  - `start.sh`: Shell script for starting the application.

- **docs/**: Contains documentation files.
  - `analysis_report.md`: Analytical report summarizing insights derived from the data.

## Getting Started

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd dockerized-data-platform
   ```

2. **Build and run the services**:
   ```
   docker-compose up --build
   ```

3. **Access the API**:
   The API will be available at `http://localhost:8000`. You can access the analytics endpoints to retrieve insights.

## Usage

- The loader service will load the CSV data into DuckDB.
- dbt will transform the data and create analytics models.
- The API will expose the transformed data for consumption.

## Notes

- Ensure Docker and Docker Compose are installed on your machine.
- Modify the `docker-compose.yml` file as needed to configure services.
- Refer to the `docs/analysis_report.md` for insights derived from the data.