from datetime import datetime
import enum
from pydantic import BaseModel
from typing import Optional


class AppointmentStatus(enum.Enum):
    AVAILABLE = 'available'
    BOOKED = 'booked'


class Appointment(BaseModel):
    id: int
    teacher_id: int
    student_id: Optional[int] = None
    apointment_time: datetime
    lesson_duration: int
    created_at: datetime
    status: AppointmentStatus


class AppointmentCreate(BaseModel):
    teacher_id: int
    student_id: Optional[int] = None
    apointment_time: datetime
    lesson_duration: int
    created_at: datetime
