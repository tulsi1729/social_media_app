import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String,Integer,DateTime
from models.base import Base


class Comment(Base):
    __tablename__  = 'comments'

    id = Column(Integer, primary_key=True, autoincrement=True) 
    post_id = Column(TEXT, ForeignKey("posts.id"))
    user_id = Column(TEXT, ForeignKey("users.id"))
    comment = Column(TEXT)
    time = Column(DateTime)

   