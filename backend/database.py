from sqlmodel import SQLModel, Field, create_engine, Session
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = "postgresql+asyncpg://user:password@localhost:5432/calendardb"

engine = create_async_engine(DATABASE_URL, echo=True)
async_session = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

async def init_db():
    async with engine.begin() as conn:
        # This will create the tables in the database
        await conn.run_sync(SQLModel.metadata.create_all)
    # Close the engine after use
    await engine.dispose()

