from contextlib import asynccontextmanager
from fastapi import FastAPI
from backend import init_db, async_session
from backend.routers import appointments, profiles, auth


@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Initialize the database on startup.
    """
    await init_db()
    yield


app = FastAPI(title="AutoSchool API")

app.include_router(auth.router, prefix="/auth", tags=["auth"])
app.include_router(profiles.router, prefix="/profiles", tags=["profiles"])
app.include_router(appointments.router,
                   prefix="/appointments", tags=["appointments"])
