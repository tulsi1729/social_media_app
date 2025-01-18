import os
import shutil
import routes
import uuid
from fastapi import APIRouter ,Form, File, Depends ,HTTPException ,UploadFile,Depends
from database import get_db
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from models.post import Post
from models.user import User
from sqlalchemy.orm import Session
import cloudinary
import cloudinary.uploader

router = APIRouter()

# Configuration       
cloudinary.config( 
    cloud_name = "dppvl48gh", 
    api_key = "793662588633836", 
    api_secret = "fO8kYKe1uzTHNVspVrPVoP5CdwU", # Click 'View API Keys' above to copy your API secret
    secure=True
)

@router.post('/upload',status_code = 201)
def upload_post(
    caption :str= Form(...),
    post_media:UploadFile = File(...),
    db:Session= Depends(get_db),
    auth_details= Depends(auth_middleware)
    
    ):
    uid = auth_details['uid']

    post_id = str(uuid.uuid4())
    post_media_res = cloudinary.uploader.upload(
        post_media.file,
        resource_type = 'image',
        folder = f'posts/{post_id}'
    )
  
    new_post = Post(
        id=post_id,
        caption=caption,  
        post_media = post_media_res['url'],
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
    post_media:UploadFile = File(...),
    db: Session = Depends(get_db),
    ):

    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    if caption:
        post.caption = caption

    if post_media :
        os.makedirs("upload", exist_ok=True)
        media_path = f"upload/{post_media.filename}"
        with open(media_path, "wb") as buffer:
            shutil.copyfileobj(post_media.file, buffer)
        post.post_media = media_path  

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

