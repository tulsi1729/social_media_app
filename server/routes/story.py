import routes
import uuid
from typing import List
import sqlalchemy
import fastapi
from fastapi import APIRouter,Form,Depends,File
from datetime import datetime
from database import get_db
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from models.user import User
from models.story import Story
from models.comment import Comment
from datetime import datetime, timedelta
from sqlalchemy import select, delete, desc

router = APIRouter()

@router.post('/create_story',status_code = 201)
def create_story(
    image_url: str = Form(...),
    views :str= Form(...),
    db:Session= Depends(get_db),
    auth_details= Depends(auth_middleware)
    ):
    uid = auth_details['uid']
    story_id = str(uuid.uuid4())   
    created_at =datetime.now()


    new_story = Story(
        id = story_id,
        image_url = image_url,
        created_at = created_at,
        views = views,
        uid = uid
    )

    db.add(new_story)
    db.commit()
    db.refresh(new_story)
    return new_story

@router.get('/get_stories')
def get_stories(
    db: Session = Depends(get_db),
    auth_details=Depends(auth_middleware)
):
    uid = auth_details['uid']
    yesterday = datetime.now() - timedelta(days = 1)
    query = (
       select(Story)
        .where(Story.created_at > yesterday)
        .where(Story.uid == uid)
       .order_by(desc(Story.created_at))
       
        
    )
    stories = db.execute(query).scalars().all()
    
    

   
    if not stories:
        raise HTTPException(status_code=404, detail="No active stories found")

    return stories


