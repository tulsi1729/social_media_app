from fastapi import FastAPI 
from routes import auth,post,story,comment,like,reel,follow
from models.base import Base
from database import engine


app = FastAPI()

app.include_router(auth.router,prefix='/auth')
app.include_router(post.router,prefix='/post')
app.include_router(like.router,prefix='/like')
app.include_router(comment.router,prefix='/comment')
app.include_router(story.router,prefix='/story')
app.include_router(reel.router,prefix='/reel')
app.include_router(follow.router,prefix='/follow')

Base.metadata.create_all(engine)