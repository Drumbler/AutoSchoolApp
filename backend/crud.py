from passlib.context import CryptContext
from sqlmodel import select
from sqlmodel.ext.asyncio.session import AsyncSession

from backend.models import Appointment, Profile, User
from backend.schemas import AppointmentCreate, ProfileCreate, UserCreate

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


# --- USERS ---
async def get_user_by_username(session: AsyncSession, username: str) -> User | None:
    result = await session.exec(select(User).where(User.username == username))
    return result.first()


async def create_user(session: AsyncSession, user_in: UserCreate) -> User:
    user = User(
        username=user_in.username,
        password_hash=pwd_context.hash(user_in.password),
        email=user_in.email,
    )
    session.add(user)
    await session.commit()
    await session.refresh(user)
    return user


# --- PROFILES ---

async def create_profile(session: AsyncSession, user_id: int, profile_in: ProfileCreate) -> Profile:
    profile = Profile(user_id=user_id, **profile_in.model_dump)
    session.add(profile)
    await session.commit()
    await session.refresh(profile)
    return profile


async def get_profiles(session: AsyncSession) -> list[Profile]:
    result = await session.exec(select(Profile))
    return result.all()


# --- APPOINTMENTS ---

async def create_appointment(session: AsyncSession, appointment_in: AppointmentCreate) -> Appointment:
    appoint = Appointment(**appointment_in.model_dump())
    session.add(appoint)
    await session.commit()
    await session.refresh(appoint)
    return appoint


async def list_appointments(session: AsyncSession) -> list[Appointment]:
    result = await session.exec(select(Appointment).order_by(Appointment.starts_at))
    return result.all()


async def get_appointment(session: AsyncSession, appointment_id: int) -> Appointment | None:
    return await session.get(Appointment, appointment_id)


async def update_appointment(session: AsyncSession, appointment_id: int, appointment_in: AppointmentCreate) -> Appointment | None:
    appointment = await session.get(Appointment, appointment_id)
    if not appointment:
        return None
    for key, value in appointment_in.model_dump.items():
        setattr(appointment, key, value)
    session.add(appointment)
    await session.commit()
    await session.refresh(appointment)
    return appointment


async def delete_appointment(session: AsyncSession, appointment_id: int) -> None:
    appointment = await session.get(Appointment, appointment_id)
    if appointment:
        await session.delete(appointment)
        await session.commit()
