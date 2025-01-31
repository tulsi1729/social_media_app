import routes
from sqlalchemy import TEXT, VARCHAR, Column,ForeignKey,String,Integer,DateTime
from models.base import Base
from sqlalchemy.orm import  relationship



class Comment(Base):
    __tablename__  = 'comments'

    id = Column(Integer, primary_key=True, autoincrement=True) 
    post_id = Column(TEXT,ForeignKey("posts.id" ,ondelete='CASCADE'))
    created_by = Column(TEXT, ForeignKey("users.id"))
    comment = Column(TEXT)
    created_at = Column(DateTime)

    # Relationship to fetch user details
    user = relationship("User", backref="comments")



   