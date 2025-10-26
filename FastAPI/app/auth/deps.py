from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from jose import jwt, JWTError
from datetime import datetime, timezone
from ..config import settings

bearer = HTTPBearer(auto_error=False)

def _verify_dev_token(token: str):
    try:
        payload = jwt.decode(token, settings.dev_jwt_secret, algorithms=["HS256"])
        exp = payload.get("exp")
        if exp and datetime.fromtimestamp(exp, tz=timezone.utc) < datetime.now(tz=timezone.utc):
            raise HTTPException(status_code=401, detail="Token expired")
        return payload
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

async def get_current_user(creds: HTTPAuthorizationCredentials | None = Depends(bearer)):
    if settings.auth_mode == "dev":
        if not creds:
            raise HTTPException(status_code=401, detail="Missing credentials")
        return _verify_dev_token(creds.credentials)
    else:
        # Auth0 (bearer access token)
        if not creds:
            raise HTTPException(status_code=401, detail="Missing credentials")
        token = creds.credentials
        try:
            # In prod you should verify with Auth0 JWKS & audience/issuer
            payload = jwt.get_unverified_claims(token)
            return payload
        except Exception:
            raise HTTPException(status_code=401, detail="Invalid token")
