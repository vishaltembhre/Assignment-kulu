#!/bin/bash

# Start the Docker containers for the data platform
docker-compose -f ../infra/docker-compose.yml up --build -d

# Wait for the services to be up and running
echo "Waiting for services to start..."
sleep 10

# # Run the data loading script
# docker-compose -f ../infra/docker-compose.yml exec loader python load_to_duckdb.py

# # Run dbt transformations
# docker-compose -f ../infra/docker-compose.yml exec dbt dbt run

# Start the API service
docker-compose -f ../infra/docker-compose.yml exec api python app.py

echo "Data platform services started successfully."