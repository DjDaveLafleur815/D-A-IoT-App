from neo4j import GraphDatabase
from app.config import settings

driver = GraphDatabase.driver(
    settings.NEO4J_URI,
    auth=(settings.NEO4J_USER, settings.NEO4J_PASS)
)

def get_db():
    with driver.session() as session:
        yield session
