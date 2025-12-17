import asyncio
import asyncpg
from tabulate import tabulate

async def show_presidents_and_supervisors():
    # Connect to database (using localhost:5433 since docker exposes it there)
    conn = await asyncpg.connect(
        user='Rahim',
        password='RaoufRaouf1212',
        database='ahl_quran_db',
        host='localhost',
        port=5433
    )
    
    try:
        # Query Presidents
        print("\n" + "="*80)
        print("📋 PRESIDENTS (المشرفون العامون)")
        print("="*80 + "\n")
        
        presidents_query = """
            SELECT 
                u.id,
                u.firstname,
                u.lastname,
                u.email,
                p.school_name,
                p.phone_number,
                u.is_active,
                p.created_at,
                p.approval_date
            FROM users u
            JOIN presidents p ON u.id = p.user_id
            ORDER BY p.created_at DESC
        """
        
        presidents = await conn.fetch(presidents_query)
        
        if presidents:
            presidents_data = []
            for p in presidents:
                status = "✅ Approved" if p['is_active'] else "⏳ Pending"
                presidents_data.append([
                    p['id'],
                    f"{p['firstname']} {p['lastname']}",
                    p['email'],
                    p['school_name'],
                    p['phone_number'] or 'N/A',
                    status,
                    p['created_at'].strftime('%Y-%m-%d')
                ])
            
            print(tabulate(
                presidents_data,
                headers=['ID', 'Name', 'Email', 'School', 'Phone', 'Status', 'Created'],
                tablefmt='grid'
            ))
            print(f"\nTotal Presidents: {len(presidents)}")
        else:
            print("No presidents found in the database.")
        
        # Query Supervisors
        print("\n" + "="*80)
        print("📋 SUPERVISORS (المشرفون)")
        print("="*80 + "\n")
        
        supervisors_query = """
            SELECT 
                u.id,
                u.firstname,
                u.lastname,
                u.email,
                u.is_active,
                s.created_at,
                creator.firstname as creator_firstname,
                creator.lastname as creator_lastname
            FROM users u
            JOIN supervisors s ON u.id = s.user_id
            LEFT JOIN users creator ON s.created_by_id = creator.id
            ORDER BY s.created_at DESC
        """
        
        supervisors = await conn.fetch(supervisors_query)
        
        if supervisors:
            supervisors_data = []
            for s in supervisors:
                status = "✅ Active" if s['is_active'] else "❌ Inactive"
                created_by = f"{s['creator_firstname']} {s['creator_lastname']}" if s['creator_firstname'] else 'N/A'
                supervisors_data.append([
                    s['id'],
                    f"{s['firstname']} {s['lastname']}",
                    s['email'],
                    status,
                    created_by,
                    s['created_at'].strftime('%Y-%m-%d')
                ])
            
            print(tabulate(
                supervisors_data,
                headers=['ID', 'Name', 'Email', 'Status', 'Created By', 'Created'],
                tablefmt='grid'
            ))
            print(f"\nTotal Supervisors: {len(supervisors)}")
        else:
            print("No supervisors found in the database.")
        
        print("\n" + "="*80 + "\n")
        
    finally:
        await conn.close()

if __name__ == "__main__":
    asyncio.run(show_presidents_and_supervisors())
