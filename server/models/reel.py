from models.base import Base
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String,DateTime
from sqlalchemy.orm import  relationship


class Reel(Base) :
    __tablename__ = 'reels'

    id = Column(TEXT, primary_key=True)
    uid = Column(TEXT, ForeignKey("users.id"))
    video_url = Column(TEXT) 
    caption = Column(TEXT)
    created_on = Column(DateTime)

    