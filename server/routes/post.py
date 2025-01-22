import os
import shutil
import routes
import uuid
from typing import List
import sqlalchemy
import fastapi
from fastapi import APIRouter,Form,Depends,File,UploadFile 
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


@router.put("/update_post/{post_id}")
def update_post(
    post_id: str,
    caption :str= Form(...),
    image_url:UploadFile = File(...),
    db: Session = Depends(get_db),
    ):

    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    if caption:
        post.caption = caption

    if image_url :
        os.makedirs("upload", exist_ok=True)
        media_path = f"upload/{image_url.filename}"
        with open(media_path, "wb") as buffer:
            shutil.copyfileobj(image_url.file, buffer)
        post.image_url = media_path  

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
    db.refresh(post)
    return {"message": "Post deleted successfully"}

@router.post("/like_post")
def like_post(
    post_id: str = Form(...),  
    db: Session = Depends(get_db),
    auth_details= Depends(auth_middleware)
):
    uid = auth_details['uid']

    # Check if the post exists
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    # Check if the user has already liked the post
    like = db.query(Like).filter(Like.liked_by == uid, Like.post_id == post_id).first()
    if like:
        raise HTTPException(status_code=400, detail="You already liked this item")

    # Add the like
    new_like = Like(liked_by=uid, post_id=post_id)
    db.add(new_like)
    db.commit()
    return {"message": "Liked successfully"}

@router.post("/create_comment")
def create_comment(
    post_id: str = Form(...),
    comment : str = Form(...),
    time : datetime = Form(...),
    db: Session = Depends(get_db),
    auth_details= Depends(auth_middleware)
    ):
    uid = auth_details['uid']

    new_comment = Comment(
        post_id=post_id,
        user_id=uid,
        comment= comment,
        time= time,
    )
    db.add(new_comment)
    db.commit()
    db.refresh(new_comment)
    return new_comment
