from pydantic_settings import BaseSettings
from pydantic import AnyHttpUrl

class Settings(BaseSettings):
    app_host: str = "0.0.0.0"
    app_port: int = 8000
    app_debug: bool = True
    cors_origins: str = "*"  # comma-separated or *

    neo4j_uri: str = "bolt://neo4j:7687"
    neo4j_user: str = "neo4j"
    neo4j_pass: str = "changeme"

    mqtt_host: str = "mqtt"
    mqtt_port: int = 1883
    mqtt_topic_base: str = "home"

    auth_mode: str = "dev"  # dev | auth0
    dev_jwt_secret: str = "devsecret"

    auth0_domain: str | None = None
    auth0_audience: str | None = None
    auth0_issuer: AnyHttpUrl | None = None

    class Config:
        env_file = ".env"
        case_sensitive = False

settings = Settings()
