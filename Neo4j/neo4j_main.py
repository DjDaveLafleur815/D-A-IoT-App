from neo4j import GraphDatabase

uri="bolt://localhost:7687"
user="neo4j"
password="changeme"

driver = GraphDatabase.driver(uri, auth=(user,password))
with driver.session() as s:
    s.run("RETURN 1")
print("✅ Connected")
driver.close()
