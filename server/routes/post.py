import os
import shutil
import routes
import uuid
from typing import List
import sqlalchemy
import fastapi
from fastapi import APIRouter,Form,Depends,File,UploadFile,HTTPException
from datetime import datetime
from database import get_db
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from models.post import Post
from models.like import Like
from models.user import User
from models.comment import Comment
import cloudinary
import cloudinary.uploader

router = APIRouter()

@router.post('/create_post',status_code = 201)
def create_post(
    caption :str= Form(...),
    image_url: str = Form(...),
    db:Session= Depends(get_db),
    auth_details= Depends(auth_middleware)
    ):
    uid = auth_details['uid']

    post_id = str(uuid.uuid4())
  
    new_post = Post(
        id=post_id,
        caption=caption,  
        image_url = image_url,
        uid = uid
    )

    db.add(new_post)
    db.commit()
    db.refresh(new_post)
    return new_post

@router.get('/get_posts')
def get_posts(db: Session=Depends(get_db),
               auth_details=Depends(auth_middleware)):
    uid = auth_details['uid']
    print(uid)
    posts = db.query(Post).filter(Post.uid != uid).all()
    return posts

@router.get('/my_posts')
def get_my_posts(db: Session=Depends(get_db),
               auth_details=Depends(auth_middleware)):
    uid = auth_details['uid']
    print(uid)
    posts = db.query(Post).filter(Post.uid == uid).all()
    return posts


@router.put("/edit_post/{post_id}")
def edit_post(
    post_id: str,
    caption :str= Form(...),
    image_url:str = Form(...),
    db: Session = Depends(get_db),
    ):

    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    if caption:
        post.caption = caption
    if image_url:
        post.image_url = image_url


    db.commit()
    db.refresh(post)
    return {"message": "Post updated successfully", "post": post}


@router.delete("/delete_post/{post_id}")
def delete_post(post_id: str, db: Session = Depends(get_db)):

    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")
    db.delete(post)
    db.commit()
    return {"message": "Post deleted successfully"}

    
@router.get("/post_counts/{user_id}")
def get_post_counts(user_id: str, db: Session = Depends(get_db)):
    post_counts = db.query(Post).filter(Post.uid == user_id).count()
    
    return {"post_counts": post_counts}


