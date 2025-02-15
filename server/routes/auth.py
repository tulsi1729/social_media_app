from middleware.auth_middleware import auth_middleware
import jwt
import uuid
import bcrypt
import fastapi
from models.user import User
from pydantic_schemas.user_create import UserCreate
from fastapi import APIRouter,Depends  
from sqlalchemy.orm import joinedload 
from database import get_db  
from sqlalchemy.orm import Session
from pydantic_schemas.user_login import UserLogin
from fastapi import Header,HTTPException,Form

router = APIRouter()
@router.post('/signup',status_code = 201 )
def signup_user(user : UserCreate,db :Session = Depends(get_db)):
    print(user.name)
    print(user.email)
    print(user.password)
   
    user_db = db.query(User).filter(User.email == user.email).first() 

    if user_db :
        raise HTTPException(400,'User with the same email already exists!')
 
    
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db = User(
        id= str(uuid.uuid4()),
        email=user.email,
        password=hashed_pw,
        name=user.name,
        bio= None,
        profile_image = None,
        user_name = None,
        )
    # add the user to db
    db.add(user_db)
    db.commit()
    db.refresh(user_db)
    return user_db

@router.post('/login')
def login_user(user : UserLogin,db: Session = Depends(get_db)):
    # check if user with same email already exits 
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db :
        raise HTTPException(400,"User with this email does not exits!")


    # password matching or not
    is_match = bcrypt.hashpw(user.password.encode(),user_db.password)

    if not is_match:
        raise HTTPException(400,'Incorrect password!')
    
    
    token = jwt.encode({'id': user_db.id}, 'password_key')
    
    return { 'token' : token ,'user': user_db}

    return user_db 


@router.get('/')
def current_user_data(db: Session=Depends(get_db), 
                     user_dict = Depends(auth_middleware)):
    user = db.query(User).filter(User.id == user_dict['uid']).first()

    if not user:
        raise HTTPException(404,'User not found! ')

    return user


@router.get('/get_user_lists')
def get_user_list(db: Session=Depends(get_db), 
                     user_dict = Depends(auth_middleware)):
    user = db.query(User).all()

    if not user:
        raise HTTPException(404,'User not found! ')

    return user


@router.put("/update_user")
def update_profile(
    profile_image:str = Form(...),
    user_name:str = Form(...),
    bio:str = Form(...),
    db: Session = Depends(get_db),
    auth_details=Depends(auth_middleware)):
    uid = auth_details['uid']
    user = db.query(User).filter(User.id == uid).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")


    user.profile_image = profile_image
    user.user_name = user_name
    user.bio = bio

    db.commit()
    db.refresh(user)  # Refresh to get updated data

    return {
        "message": "Profile updated successfully",
        "user" : user,
    }

@router.get("/user/get_user", status_code=200)
def get_profile(
    db: Session = Depends(get_db),
    auth_details=Depends(auth_middleware)
):
    uid = auth_details['uid']
    profile = db.query(User).filter(User.id == uid).all()

    return {"message": "user get successfully", "user": profile}

    