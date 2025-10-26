import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
    AUTH_MODE = os.getenv("AUTH_MODE", "dev")  # "dev" ou "auth0"
    DEV_JWT_SECRET = os.getenv("DEV_JWT_SECRET", "devsecret")

    AUTH0_DOMAIN = os.getenv("AUTH0_DOMAIN")
    AUTH0_AUDIENCE = os.getenv("AUTH0_AUDIENCE")
    AUTH0_ISSUER = os.getenv("AUTH0_ISSUER")

    NEO4J_URI = os.getenv("NEO4J_URI")
    NEO4J_USER = os.getenv("NEO4J_USER")
    NEO4J_PASS = os.getenv("NEO4J_PASS")

settings = Settings()
