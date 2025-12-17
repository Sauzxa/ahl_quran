"""
Script to verify and display PostgreSQL database encoding settings.
Run this to ensure your database supports Arabic characters properly.
"""
import asyncio
from sqlalchemy import text
from app.db.session import engine


async def verify_encoding():
    """Check database encoding settings"""
    async with engine.begin() as conn:
        print("=" * 60)
        print("PostgreSQL Database Encoding Verification")
        print("=" * 60)
        
        # Check database encoding
        result = await conn.execute(
            text("SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = current_database()")
        )
        encoding = result.scalar()
        print(f"✓ Database Encoding: {encoding}")
        
        # Check client encoding
        result = await conn.execute(text("SHOW client_encoding"))
        client_encoding = result.scalar()
        print(f"✓ Client Encoding: {client_encoding}")
        
        # Check server encoding
        result = await conn.execute(text("SHOW server_encoding"))
        server_encoding = result.scalar()
        print(f"✓ Server Encoding: {server_encoding}")
        
        # Check LC_COLLATE
        result = await conn.execute(
            text("SELECT datcollate FROM pg_database WHERE datname = current_database()")
        )
        collate = result.scalar()
        print(f"✓ LC_COLLATE: {collate}")
        
        # Check LC_CTYPE
        result = await conn.execute(
            text("SELECT datctype FROM pg_database WHERE datname = current_database()")
        )
        ctype = result.scalar()
        print(f"✓ LC_CTYPE: {ctype}")
        
        print("\n" + "=" * 60)
        
        # Test Arabic text
        print("\nTesting Arabic text storage and retrieval...")
        test_text = "أحمد محمد"
        
        # Create test table
        await conn.execute(text("""
            CREATE TABLE IF NOT EXISTS test_arabic (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100)
            )
        """))
        
        # Insert Arabic text
        await conn.execute(
            text("INSERT INTO test_arabic (name) VALUES (:name)"),
            {"name": test_text}
        )
        
        # Retrieve Arabic text
        result = await conn.execute(text("SELECT name FROM test_arabic ORDER BY id DESC LIMIT 1"))
        retrieved_text = result.scalar()
        
        # Clean up
        await conn.execute(text("DROP TABLE test_arabic"))
        
        if retrieved_text == test_text:
            print(f"✓ Arabic text test PASSED: '{retrieved_text}'")
            print("\n✅ Database is properly configured for Arabic text!")
        else:
            print(f"✗ Arabic text test FAILED")
            print(f"  Expected: '{test_text}'")
            print(f"  Got: '{retrieved_text}'")
            print("\n⚠️  Database may have encoding issues!")
        
        print("=" * 60)


if __name__ == "__main__":
    asyncio.run(verify_encoding())
