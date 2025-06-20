from datetime import datetime, time
from typing import List, Optional
from sqlmodel import Field, Relationship, SQLModel


class User(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    username: str = Field(index=True, nullable=False, unique=True)
    name: str = Field(nullable=False, unique=False)
    surname: str = Field(nullable=False, unique=False)
    password_hash: str = Field(nullable=False)
    email: str = Field(index=True, nullable=False, unique=True)
    created_at: datetime = Field(default_factory=time.time)

    profile: "Profile" = Relationship(back_populates='user', uselist=False)
    roles: List["Role"] = Relationship(
        back_populates='users', link_model="UserRole")


class Role(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    name: str = Field(unique=True, nullable=False)
    users: List[User] = Relationship(
        back_populates='roles', link_model="UserRole")


class UserRole(SQLModel, table=True):
    user_id: Optional[int] = Field(
        default=None, foreign_key="user.id", primary_key=True)
    role_id: Optional[int] = Field(
        default=None, foreign_key="role.id", primary_key=True)


class Profile(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    user_id: int = Field(foreign_key="user.id", nullable=False)
    profile_type: str
    full_name: str
    phone: Optional[str]
    licence_category: Optional[str]
    car_model: Optional[str]
    department: Optional[str]

    user: User = Relationship(back_populates="profile")

    appointments_as_students: List["Appointment"] = Relationship(
        back_populates="student", sa_relationship_kwargs={
            "primaryjoin": "Appointment.student_profile_id==Profile.id"}
    )
    appointments_as_teacher: List["Appointment"] = Relationship(
        back_populates="teacher", sa_relationship_kwargs={
            "primaryjoin": "Appointment.teacher_profile_id==Profile.id"}
    )


class Appointment(SQLModel, table=True):
    id: Optional[int] = Field(default=None, primary_key=True)
    student_profile_id: int = Field(foreign_key="profile.id", nullable=False)
    teacher_profile_id: int = Field(foreign_key="profile.id", nullable=False)
    starts_at: datetime
    ends_at: Optional[datetime]
    created_at: datetime = Field(default_factory=time.time)
    student: Optional[Profile] = Relationship(
        back_populates="appointments_as_student")
    teacher: Optional[Profile] = Relationship(
        back_populates="appointments_as_teacher")
