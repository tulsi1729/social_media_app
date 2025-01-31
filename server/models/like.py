import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String,Integer
from models.base import Base


class Like(Base):
    __tablename__  = 'likes'

    id = Column(Integer, primary_key=True, autoincrement=True) 
    post_id = Column(TEXT,ForeignKey("posts.id" ,ondelete='CASCADE'))
    liked_by = Column(TEXT, ForeignKey("users.id"))
