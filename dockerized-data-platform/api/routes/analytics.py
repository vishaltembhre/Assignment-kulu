from fastapi import APIRouter, HTTPException
import duckdb
import os
import pandas as pd
import numpy as np

router = APIRouter()

def get_db_connection():
    db_path = os.getenv("DB_PATH", "../data/analytics.db")
    try:
        conn = duckdb.connect(db_path, read_only=True)
        return conn
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")

def _sanitize_df_for_json(df: pd.DataFrame) -> pd.DataFrame:
    # Replace infinities with NaN, then replace NaN with None so JSON encoder will produce null
    df = df.replace([np.inf, -np.inf], np.nan)
    df = df.where(pd.notnull(df), None)
    return df

@router.get("/kyc-growth")
def kyc_growth():
    conn = get_db_connection()
    try:
        df = conn.execute("SELECT * FROM dbt_solution.fct_kyc_daily").fetchdf()
        df = _sanitize_df_for_json(df)
        return df.to_dict(orient="records")
    finally:
        conn.close()

@router.get("/top-users")
def top_users():
    conn = get_db_connection()
    try:
        df = conn.execute("SELECT * FROM dbt_solution.fct_top_users_daily ORDER BY transaction_date DESC, daily_amount DESC").fetchdf()
        df = _sanitize_df_for_json(df)
        return df.to_dict(orient="records")
    finally:
        conn.close()

@router.get("/transaction-stats")
def transaction_stats():
    conn = get_db_connection()
    try:
        df = conn.execute("SELECT * FROM dbt_solution.fct_transaction_stats").fetchdf()
        df = _sanitize_df_for_json(df)
        return df.to_dict(orient="records")
    finally:
        conn.close()

@router.get("/merchant-analysis")
def merchant_analysis():
    conn = get_db_connection()
    try:
        df = conn.execute("SELECT * FROM dbt_solution.fct_merchant_analysis").fetchdf()
        df = _sanitize_df_for_json(df)
        return df.to_dict(orient="records")
    finally:
        conn.close()
