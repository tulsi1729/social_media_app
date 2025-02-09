import fastapi
from sqlalchemy.orm import Session
from fastapi import APIRouter,Form,Depends,Body
from database import get_db 
from models.follow import Follow
from models.user import User
from middleware.auth_middleware import auth_middleware
from routes.auth import current_user_data, router

router = APIRouter()

@router.get("/user/follow_counts/{user_id}")
def get_follow_counts(user_id: str, db: Session = Depends(get_db)):
    follower_count = db.query(Follow).filter(Follow.following == user_id).count()
    following_count = db.query(Follow).filter(Follow.follower == user_id).count()
    
    return {"follower_count": follower_count, "following_count": following_count}


@router.post("/{target_user_id}")
def follow_user(
    target_user_id: str,
    db: Session = Depends(get_db),
    auth_details= Depends(auth_middleware),):
    uid = auth_details['uid']

    if uid == target_user_id:
        raise HTTPException(status_code=400, detail="You cannot follow yourself.")

    user_to_follow = db.query(User).filter(User.id == target_user_id).first()
    if not user_to_follow:
        raise HTTPException(status_code=404, detail="User not found.")

    existing_follow = db.query(Follow).filter(
        Follow.follower == uid,
        Follow.following == target_user_id
    ).first()

    if existing_follow:
        raise HTTPException(status_code=400, detail="Already following this user.")

    follow = Follow(follower=uid, following=target_user_id)
    db.add(follow)
    db.commit()
    return {"message": "Followed successfully"}

@router.delete("/unfollow/{target_user_id}")
def unfollow_user(
    target_user_id: str,
    db: Session = Depends(get_db),
    auth_details= Depends(auth_middleware),
):
    uid = auth_details['uid']

    # Check if the user is trying to unfollow themselves
    if uid == target_user_id:
        raise HTTPException(status_code=400, detail="You cannot unfollow yourself.")

    # Check if the target user exists
    user_to_unfollow = db.query(User).filter(User.id == target_user_id).first()
    if not user_to_unfollow:
        raise HTTPException(status_code=404, detail="Target user not found.")

    # Check if there is a follow relationship
    existing_follow = db.query(Follow).filter(
        Follow.follower == uid,
        Follow.following == target_user_id
    ).first()

    # If the user is not following, raise an error
    if not existing_follow:
        raise HTTPException(status_code=400, detail="Not following this user.")

    # Remove the follow relationship (unfollow)
    db.delete(existing_follow)
    db.commit()

    return {"message": "Unfollowed successfully"}
