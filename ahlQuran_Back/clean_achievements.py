"""
Script to clean all achievement data from the database
"""
import asyncio
from sqlalchemy import delete
from app.db.session import async_session_maker
from app.models.acheivements import Achievement


async def clean_achievements():
    """Delete all achievement records from the database"""
    async with async_session_maker() as session:
        try:
            # Delete all achievements
            result = await session.execute(delete(Achievement))
            await session.commit()
            
            print(f"✅ Successfully deleted {result.rowcount} achievement records")
            
        except Exception as e:
            await session.rollback()
            print(f"❌ Error cleaning achievements: {e}")
            raise


if __name__ == "__main__":
    print("🧹 Cleaning achievement data...")
    asyncio.run(clean_achievements())
    print("✨ Done!")
