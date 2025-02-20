import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String,DateTime
from models.base import Base
from typing import List


class Story(Base):
    __tablename__ = 'stories'

    id = Column(TEXT, primary_key=True)
    image_url = Column(TEXT)
    created_on = Column(DateTime)
    views = Column(TEXT)
    uid = Column(TEXT,ForeignKey("users.id"))