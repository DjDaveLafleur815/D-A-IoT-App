# utilisé seulement en mode Auth0
# ton futur JWKS live
import httpx
from functools import lru_cache
from . import jwks
from ..config import settings

@lru_cache(maxsize=1)
def get_auth0_jwks():
    if not settings.auth0_domain:
        raise RuntimeError("AUTH0_DOMAIN missing")
    url = f"https://{settings.auth0_domain}/.well-known/jwks.json"
    r = httpx.get(url, timeout=10)
    r.raise_for_status()
    return r.json()
