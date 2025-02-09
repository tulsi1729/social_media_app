import datetime
from models.base import Base
from sqlalchemy import TEXT,Column,ForeignKey,Integer

class Follow(Base):
    __tablename__ = 'follows'

    id = Column(Integer, primary_key=True,autoincrement = True)
    follower = Column(TEXT,ForeignKey("users.id"))
    following = Column(TEXT,ForeignKey("users.id"))   
    