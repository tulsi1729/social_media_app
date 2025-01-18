from fastapi import FastAPI 
from models.base import Base
from routes import auth,post
from models.base import Base
from database import engine


app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(post.router,prefix='/post')

Base.metadata.create_all(engine)