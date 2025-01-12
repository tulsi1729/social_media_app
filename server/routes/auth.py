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
from fastapi import Header,HTTPException

router = APIRouter()
@router.post('/signup',status_code = 201 )
def signup_user(user : UserCreate,db :Session = Depends(get_db)):
    print(user.name)
    print(user.email)
    print(user.password)
    # extract data that coming from req
    # check is user already exits in db
    user_db = db.query(User).filter(User.email == user.email).first() 

    if user_db :
        raise HTTPException(400,'User with the same email already exists!')
 
    
    hashed_pw = bcrypt.hashpw(user.password.encode(),bcrypt.gensalt())
    user_db = User(id= str(uuid.uuid4()),email=user.email,password=hashed_pw,name=user.name)
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

