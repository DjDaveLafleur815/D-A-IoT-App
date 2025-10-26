from fastapi import APIRouter, HTTPException, Depends
from jose import jwt
from datetime import datetime, timedelta, timezone
from ..models.dto import UserCreate, UserOut
from ..neo4j_client import get_driver
from ..config import settings
from ..auth.deps import get_current_user

router = APIRouter(prefix="/users", tags=["users"])

@router.post("/register", response_model=UserOut)
def register(user: UserCreate):
    """Dev-mode registration: store User in Neo4j."""
    with get_driver().session() as s:
        r = s.run("""
            MERGE (u:User {email: $email})
            ON CREATE SET u.display_name=$display_name
            RETURN u.email AS email, u.display_name AS display_name
        """, email=user.email, display_name=user.display_name)
        rec = r.single()
        return UserOut(email=rec["email"], display_name=rec["display_name"])

@router.post("/login")
def login(user: UserCreate):
    """Dev-mode login: returns a signed JWT to use as Bearer token."""
    if settings.auth_mode != "dev":
        raise HTTPException(400, "login endpoint only for dev mode")

    payload = {
        "sub": user.email,
        "email": user.email,
        "name": user.display_name or user.email.split("@")[0],
        "iat": int(datetime.now(tz=timezone.utc).timestamp()),
        "exp": int((datetime.now(tz=timezone.utc) + timedelta(hours=8)).timestamp())
    }
    token = jwt.encode(payload, settings.dev_jwt_secret, algorithm="HS256")
    return {"access_token": token, "token_type": "bearer"}

@router.get("/me", response_model=UserOut)
def me(claims=Depends(get_current_user)):
    return UserOut(email=claims.get("email"), display_name=claims.get("name"))
