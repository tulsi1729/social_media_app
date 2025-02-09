import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String
from models.base import Base    
from sqlalchemy.orm import  relationship
from models.like import Like
from models.comment import Comment


class Post(Base):
    __tablename__ = 'posts'

    id = Column(TEXT, primary_key=True)
    caption = Column(TEXT)
    image_url = Column(TEXT)    
    uid = Column(TEXT, ForeignKey("users.id"))

    like = relationship(Like ,backref= 'posts' ,cascade="all, delete-orphan",passive_deletes=True)
    comment = relationship(Comment ,backref= 'posts' ,cascade="all, delete-orphan",passive_deletes=True)

