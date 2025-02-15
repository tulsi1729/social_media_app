from fastapi import APIRouter,Form,Depends,File,UploadFile,HTTPException
from datetime import datetime
from database import get_db
from sqlalchemy.orm import Session
from middleware.auth_middleware import auth_middleware
from models.reel import Reel
import routes
import uuid

router = APIRouter()

@router.post('/create_reel',status_code = 201)
def create_reel(
    caption :str= Form(...),
    video_url: str = Form(...),
    db:Session= Depends(get_db),
    auth_details= Depends(auth_middleware)
    ):
    uid = auth_details['uid']
    reel_id = str(uuid.uuid4())
    created_on =datetime.now()
   
    new_reel = Reel(
        id=reel_id,
        uid = uid,
        video_url = video_url,
        caption=caption,  
        created_on = created_on,
    )

    db.add(new_reel)
    db.commit()
    db.refresh(new_reel)
    return {"message": "Reel created successfully", "reel": new_reel}

@router.get("/get_reels", status_code=200)
def get_reels(
    db: Session = Depends(get_db),
    auth_details=Depends(auth_middleware)
):

    reels = db.query(Reel).all()

    return {"message": "Reels get successfully", "reels": reels}


@router.delete("/delete_reel/{reel_id}")
def delete_reel(reel_id: str, db: Session = Depends(get_db)):

    reel = db.query(Reel).filter(Reel.id == reel_id).first()
    if not reel:
        raise HTTPException(status_code=404, detail="Post not found")
    db.delete(reel)
    db.commit()
    return {"message": "Reel deleted successfully"}

    