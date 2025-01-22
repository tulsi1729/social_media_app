import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String
from models.base import Base


class Post(Base):
    __tablename__ = 'posts'

    id = Column(TEXT, primary_key=True)
    caption = Column(TEXT)
    image_url = Column(TEXT) 
    uid = Column(TEXT, ForeignKey("users.id"))