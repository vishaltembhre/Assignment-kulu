from fastapi import FastAPI
from routes.analytics import router as analytics_router

app = FastAPI(title="Kulu Data Platform API", version="1.0.0")

app.include_router(analytics_router, prefix="/api/v1", tags=["analytics"])

@app.get("/")
def read_root():
    return {"message": "Welcome to the Data Platform API"}
