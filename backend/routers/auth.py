from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, status
from backend.core.exceptions import CredentialException, UserAlreadyExistsException, UserNotFoundException
from backend.crud import get_user_by_email, pwd_context
from backend.core.auth import ACCESS_TOKEN_EXPIRE_MINUTES, create_access_token, get_current_user
from backend.core.auth import get_session
from backend.routers import profiles
from backend.schemas import Token, UserCreate, UserRead


router = APIRouter(prefix='/auth',tags=["auth"])


@router.post("/register",
          response_model=UserRead,
          status_code=status.HTTP_201_CREATED)
async def register(user_input: UserCreate, session: AsyncSession = Depends(get_session)):
    existing = await get_user_by_email(session, user_input.email)
    if existing: raise UserAlreadyExistsException('Пользователь с данным email уже существует')
    user = await profiles.create_user_profile(session, user_input)
    return user


@router.post('/login',
          response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), session: AsyncSession = Depends(get_session)):
    user = await get_user_by_email(session, form_data.email)
    if not user.email:
        raise UserNotFoundException()
    if not user or pwd_context.verify(form_data.password, user.hashed_password):
        raise CredentialException(detail="Incorrect username or password")
    access_token = create_access_token(data={"sub": user.email},
                                       expires_delta=ACCESS_TOKEN_EXPIRE_MINUTES)
    return {'access_token': access_token, 'token_type': 'bearer'}


@router.get('/me', response_model=UserRead)
async def read_current_user(current_user = Depends(get_current_user)):
    return current_user
