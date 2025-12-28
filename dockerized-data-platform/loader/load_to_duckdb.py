import duckdb
import os
import glob

def load_data():
    # Define paths
    # We use environment variables to make it flexible for Docker vs Local
    # Default to assuming we run from 'dockerized-data-platform' root or similar
    
    # We want to put the DB in 'data/' inside dockerized-data-platform so it is shared
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    db_path = os.getenv('DB_PATH', os.path.join(base_dir, 'data', 'analytics.db'))
    
    # Check if /data exists (Docker)
    if os.getenv('DATA_DIR'):
        data_dir = os.environ['DATA_DIR']
    elif os.path.exists('/data/users.csv'):
        data_dir = '/data'
    else:
        # Fallback to local
        data_dir = os.path.join(base_dir, 'data')

    print(f"Connecting to DuckDB at {db_path}...")
    conn = duckdb.connect(db_path)

    schema = os.getenv("DB_SCHEMA", "source")
    conn.execute(f"CREATE SCHEMA IF NOT EXISTS {schema}")

    # List of tables to load
    tables = {
        'users': 'users.csv',
        'onboarding': 'onboarding.csv',
        'transactions': 'transactions.csv'
    }

    for table_name, csv_file in tables.items():
        csv_path = os.path.join(data_dir, csv_file)
        if os.path.exists(csv_path):
            print(f"Loading {table_name} from {csv_path}...")
            conn.execute(f"CREATE OR REPLACE TABLE {schema}.{table_name} AS SELECT * FROM read_csv_auto('{csv_path}')")
            print(f"Successfully loaded {schema}.{table_name}.")
        else:
            print(f"WARNING: {csv_path} not found. Skipping {table_name}.")

    # Verify tables
    print("\nTables in database:")
    print(conn.execute("SHOW TABLES").fetchall())

    conn.close()
    print("Data ingestion complete.")

if __name__ == "__main__":
    load_data()
