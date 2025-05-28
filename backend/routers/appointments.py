

from datetime import date, datetime, time
from typing import Optional
from fastapi import APIRouter, Query, status
from sqlmodel import select

from backend.core.auth import get_current_user, get_session
from backend.core.exceptions import AppointmentNotFoundException
from backend.crud import create_appointment, get_appointment, list_appointments
from backend.models import Appointment
from backend.schemas import AppointmentCreate, AppointmentRead
from sqlalchemy.ext.asyncio import AsyncSession
from fastapi import Depends
from fastapi import HTTPException


router = APIRouter(tags=["appointments"])


@router.post("/", response_model=AppointmentRead, status_code=status.HTTP_201_CREATED)
async def create_new_appointment(
    appoint_in: AppointmentCreate,
    current_user=Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    if current_user.profile.profile_type == "student":
        if appoint_in.student_profile_id != current_user.profile.id:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                                detail="Student profile ID does not match the current user's profile ID")
        appoint = await create_appointment(session, appoint_in)
        return appoint
    elif current_user.profile.profile_type == "teacher":
        new_appoint = AppointmentCreate(
            student_profile_id=appoint_in.student_profile_id,
            teacher_profile_id=current_user.profile.id,
            starts_at=appoint_in.starts_at,
            ends_at=appoint_in.ends_at
        )
        appoint = await create_appointment(session, new_appoint)
        return appoint
    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Invalid profile type")


@router.get("/", response_model=list[AppointmentRead])
async def get_appointments(
    date_filter: Optional[date] = Query(
        None, description="Filter appointments by date"),
    current_user=Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    if current_user.profile.profile_type == "student":
        stmt = select(Appointment).where(
            Appointment.student_profile_id == current_user.profile.id)
    elif current_user.profile.profile_type == "teacher":
        stmt = select(Appointment).where(
            Appointment.teacher_profile_id == current_user.profile.id)
    else:
        stmt = select(Appointment)
    if date_filter:
        start_dt = datetime.combine(date_filter, time.min)
        end_dt = datetime.combine(date_filter, time.max)
        stmt = stmt.where(Appointment.starts_at >= start_dt).where(
            Appointment.ends_at <= end_dt)
    result = await session.exec(stmt.order_by(Appointment.starts_at))
    return result.all()


@router.get("/{appointment_id}", response_model=AppointmentRead)
async def read_appointment(
    appointment_id: int,
    current_user=Depends(get_current_user),
    session: AsyncSession = Depends(get_session)
):
    appoint = await get_appointment(session, appointment_id)
    if not appoint:
        raise AppointmentNotFoundException()
    own = (
        (current_user.profile.profile_type == 'student' and appoint.student_profile_id == current_user.profile.id) or
        (current_user.profile.profile_type == 'teacher' and appoint.teacher_profile_id == current_user.profile.id)
    )
    if not own and current_user.prfile.profile_type not in ('manager', 'admin'):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN, detail="Access denied")
    return appoint


