import pytest
import pytest
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
import json
from fastapi.testclient import TestClient
from app import app

@pytest.fixture
def client():
    with TestClient(app) as c:
        yield c

def test_get_kyc_growth(client):
    response = client.get('/api/v1/kyc-growth')
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)

def test_get_top_users(client):
    response = client.get('/api/v1/top-users')
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)

def test_get_transaction_stats(client):
    response = client.get('/api/v1/transaction-stats')
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)

def test_get_merchant_analysis(client):
    response = client.get('/api/v1/merchant-analysis')
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)