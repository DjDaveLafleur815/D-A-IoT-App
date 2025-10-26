from fastapi import Depends, HTTPException
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import jwt
from app.config import settings

bearer = HTTPBearer()

def get_user_token(creds: HTTPAuthorizationCredentials = Depends(bearer)):
    token = creds.credentials

    if settings.AUTH_MODE == "dev":
        try:
            decoded = jwt.decode(token, settings.DEV_JWT_SECRET, algorithms=["HS256"])
            return decoded["sub"]
        except:
            raise HTTPException(401, "Invalid token")

    if settings.AUTH_MODE == "auth0":
        # Auth0 validation (JWKS)
        # laissée simple volontairement
        return "auth0-user"

    raise HTTPException(401, "Auth misconfigured")
