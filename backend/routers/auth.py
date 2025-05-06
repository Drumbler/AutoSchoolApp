from datetime import timedelta
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, HTTPException, status
from backend.core.exceptions import CredentialException, UserAlreadyExistsException
from backend.crud import pwd_context
from backend.core.auth import ACCESS_TOKEN_EXPIRE_MINUTES, create_access_token, get_current_user

from backend.core.auth import get_session
from backend.crud import create_user, get_user_by_username
from backend.models import User
from backend.schemas import Token, UserCreate, UserRead


router = APIRouter(tags=["auth"])


@router.post("/register", response_model=UserRead, status_code=status.HTTP_201_CREATED)
async def register(user_in: UserCreate, session: AsyncSession = Depends(get_session)):
    existing = await get_user_by_username(session, user_in.username)
    if existing:
        raise UserAlreadyExistsException(detail="Username already registered")
    user = await create_user(session, user_in)
    return user


@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), session: AsyncSession = Depends(get_session)):
    user = await get_user_by_username(session, form_data.username)
    if not user or not pwd_context.verify(form_data.password, user.password_hash):
        raise CredentialException(detail="Incorrect username or password")

    access_token = create_access_token(
        data={"sub": user.username},
        expires_delta=timedelta(minute=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.get("/me", response_model=UserRead)
async def read_currnet_user(current_user: User = Depends(get_current_user)):
    return current_user
