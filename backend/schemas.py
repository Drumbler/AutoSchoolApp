from datetime import datetime
from typing import Optional
from pydantic import BaseModel, EmailStr


class UserCreate(BaseModel):
    username: str
    password: str
    email: EmailStr


class UserRead(BaseModel):
    id: int
    username: str
    email: EmailStr
    created_at: datetime

    class Config:
        orm_mode = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


class ProfileCreate(BaseModel):
    profile_type: str
    full_name: str
    phone: Optional[str]
    licence_category: Optional[str]
    car_model: Optional[str]
    department: Optional[str]


class ProfileRead(ProfileCreate):
    id: int
    user_id: int

    class Config:
        orm_mode = True


class AppointmentCreate(BaseModel):
    student_profile_id: int
    teacher_profile_id: int
    starts_at: datetime
    ends_at: Optional[datetime]


class AppointmentRead(AppointmentCreate):
    id: int
    created_at: datetime

    class Config:
        orm_mode = True
