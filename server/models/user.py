from sqlalchemy import  TEXT,Column,VARCHAR,LargeBinary
from models.base import Base
from sqlalchemy.orm import  relationship

class User(Base):
    __tablename__ = 'users'

    id = Column(TEXT,primary_key = True )
    name = Column(VARCHAR(100))
    email = Column(VARCHAR(100))
    password = Column(LargeBinary)
    profile_image = Column(TEXT,nullable=True)
    bio = Column(TEXT,nullable=True)
    user_name = Column(TEXT,nullable=True)


