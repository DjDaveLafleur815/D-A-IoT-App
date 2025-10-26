from fastapi import APIRouter, Depends, HTTPException
from app.models.dto import UserDTO
from app.neo4j_client import get_db
import jwt
from app.config import settings
from app.auth.deps import get_user_token

router = APIRouter(prefix="/users")

@router.post("/register")
def register(body: UserDTO, db=Depends(get_db)):
    db.run("""
        CREATE (u:User {email:$email, password:$password})
    """, email=body.email, password=body.password)

    return {"ok": True}

@router.post("/login")
def login(body: UserDTO, db=Depends(get_db)):
    res = db.run("""
        MATCH (u:User {email:$email, password:$password})
        RETURN u LIMIT 1
    """, email=body.email, password=body.password).single()

    if not res:
        raise HTTPException(401, "Invalid credentials")

    token = jwt.encode({"sub": body.email}, settings.DEV_JWT_SECRET, algorithm="HS256")

    return {"token": token}

@router.get("/me")
def me(user=Depends(get_user_token)):
    return {"user": user}
