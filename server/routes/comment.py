import routes
import sqlalchemy
import fastapi
from fastapi import APIRouter,Form,Depends,File,UploadFile 
from datetime import datetime
from database import get_db
from sqlalchemy.orm import Session, relationship, joinedload
from middleware.auth_middleware import auth_middleware
from models.post import Post
from models.user import User
from models.comment import Comment
from datetime import datetime
from fastapi import Form, Depends, HTTPException
from database import get_db 

router = APIRouter()

@router.post("/create_comment") 
def create_comment(
    post_id: str = Form(...),
    comment: str = Form(...),
    created_at: datetime = datetime.now(),  
    db: Session = Depends(get_db),
    auth_details=Depends(auth_middleware)
):
    # Validate post_id
    post = db.query(Post).filter(Post.id == post_id).first()
    if not post:
        raise HTTPException(status_code=404, detail="Post not found")

    # Extract the authenticated user's ID or name
    created_by = auth_details.get('uid')  # Assuming 'id' is in auth_details
    if not created_by:
        raise HTTPException(status_code=401, detail="Unauthorized")

    # Create new comment
    new_comment = Comment(
        post_id=post_id,
        created_by=created_by,
        comment=comment,
        created_at=created_at
    )
    db.add(new_comment)
    db.commit()
    db.refresh(new_comment)

    # Return the new comment (serialized)
    return {
        "id": new_comment.id,
        "post_id": new_comment.post_id,
        "created_by": new_comment.created_by,
        "comment": new_comment.comment,
        "created_at": new_comment.created_at
    }


@router.get("/get_comments/{post_id}")
def get_comments(post_id : str, db: Session = Depends(get_db)):
    # Query to fetch comments for a specific post_id
    comments = db.query(Comment).options(joinedload(Comment.user)).filter(Comment.post_id == post_id).all()

    if not comments:
        raise HTTPException(status_code=404, detail="No comments found for this post")

    return [
        {
            "id": comment.id,
            "comment": comment.comment,
            "post_id": comment.post_id,
            "created_by": comment.user.name if comment.user else None,
            "created_on": comment.created_at
        }
        for comment in comments
    ]

@router.delete("/delete_comment/{comment_id}")
def delete_comment(comment_id: str, db: Session = Depends(get_db)):
    comment = db.query(Comment).filter(Comment.id == comment_id).one()

    if not comment:
        raise HTTPException(status_code=404, detail="Comment not found")

    db.delete(comment)
    db.commit()

    return {"message": "Comment deleted successfully"}


@router.get("/post_comments_count/{post_id}")
def get_post_comment_counts(post_id: str, db: Session = Depends(get_db)):
    post_comments_count = db.query(Comment).filter(Comment.post_id == post_id).count()
    
    return {"post_comments_count": post_comments_count}
