from fastapi import APIRouter,Form,Depends,File,UploadFile 
from datetime import datetime
from database import get_db
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from models.post import Post
from models.like import Like
from models.user import User
from models.comment import Comment
from routes.post import create_post

router = APIRouter()

@router.post("/create_like")
def create_like(
    post_id: str = Form(...),  
    db: Session = Depends(get_db),
    auth_details= Depends(auth_middleware)
):
    uid = auth_details['uid']

    like = db.query(Like).filter(Like.liked_by == uid, Like.post_id == post_id).first()
    if like:
        db.delete(like)
        db.commit()
        return {"message": "unLiked successfully"}
    
    else :
        new_like = Like(liked_by=uid, post_id=post_id)
        db.add(new_like)
        db.commit()
        return {"message": "Liked successfully"}

@router.get("/get_likes")
def get_likes(post_id: str = Form(...), db: Session = Depends(get_db)):
    likes = db.query(Like).filter(Like.post_id == post_id).first()
    return {"likes": likes}