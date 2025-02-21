from typing import List
from fastapi import FastAPI

from models import Appointment, AppointmentCreate, AppointmentStatus


app = FastAPI()
fake_db: List = []


@app.post('/appointment/', response_model=Appointment)
def create_appointment(appointment: AppointmentCreate):
    new_appointment = Appointment(
        id=len(fake_db) + 1,
        **appointment.model_dump(),
        status=AppointmentStatus.AVAILABLE)
    fake_db.append(new_appointment)
    return new_appointment



