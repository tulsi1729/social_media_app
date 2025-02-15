from pydantic import BaseModel
from typing import Optional  
import sqlalchemy
class UserCreate(BaseModel):
    name:str
    email:str
    password:str
    profile_image:Optional[str] = None
    bio:Optional[str] = None 
    user_name:Optional[str] = None