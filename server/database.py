from sqlalchemy import create_engine 
from sqlalchemy.orm import sessionmaker

DATABASE_url = 'postgresql://postgres:root@localhost:5432/socialmediaapp'

engine = create_engine(DATABASE_url)
SessionLocal = sessionmaker(autocommit = False,autoflush = False,bind= engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()