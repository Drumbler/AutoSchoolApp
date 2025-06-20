from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import APIRouter, Depends, status
from sqlmodel import select

from backend.core.auth import get_current_user, get_session
from backend.core.exceptions import UserAlreadyExistsException
from backend.crud import create_profile, get_profiles
from backend.models import Profile
from backend.schemas import ProfileCreate, ProfileRead


router = APIRouter(tags=["profiles"])


@router.post("/", response_model=ProfileRead, status_code=status.HTTP_201_CREATED)
async def create_user_profile(
    profile_in: ProfileCreate,
    current_user=Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    existing_profiles = await session.exec(select(Profile).where(Profile.user_id == current_user.id))
    if existing_profiles.first():
        raise UserAlreadyExistsException(detail="profile already exists")
    profile = await create_profile(session, current_user.id, profile_in)
    return profile
