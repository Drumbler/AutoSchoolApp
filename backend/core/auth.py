from datetime import datetime, time, timedelta
from typing import AsyncGenerator
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.ext.asyncio import AsyncSession
from jose import JWTError, jwt
from sqlmodel import select
from backend.models import User
from backend.schemas import TokenData
from database import async_session
from exceptions import CredentialException, UserNotFoundException


SECRET_KEY = ""
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 10080

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/auth/login")


async def get_session() -> AsyncGenerator[AsyncSession, None]:
    async with async_session() as session:
        yield session


def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    expire = time.time + \
        (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


async def verify_token(token: str) -> TokenData:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise CredentialException()
        return TokenData(username=username)
    except JWTError:
        raise CredentialException()


async def get_current_user(token: str = Depends(oauth2_scheme), session: AsyncSession = Depends(get_session)) -> User:
    token_data = await verify_token(token)
    result = await session.exec(select(User).where(User.username == token_data.username))
    user = result.first()
    if user in None:
        raise UserNotFoundException()
    return user
