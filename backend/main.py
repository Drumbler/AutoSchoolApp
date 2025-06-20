from contextlib import asynccontextmanager
from fastapi import Depends, FastAPI
from fastapi.security import OAuth2PasswordRequestForm
from backend import init_db, async_session
from sqlalchemy.ext.asyncio import AsyncSession
from backend.core.auth import create_access_token, get_session
from backend.crud import get_user_by_username
from backend.routers import appointments, profiles, auth
from backend.schemas import Token, UserCreate, UserRead
from fastapi import status
from fastapi import HTTPException
from passlib.apps import custom_app_context as pwd_context


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
