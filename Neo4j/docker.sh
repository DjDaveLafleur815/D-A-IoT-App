#!/usr/bin/env bash
docker run -it --rm \
  -p 7474:7474 -p 7687:7687 \
  -e NEO4J_AUTH=neo4j/changeme \
  -e NEO4J_PLUGINS='["apoc"]' \
  -v "$(pwd)/data":/data \
  -v "$(pwd)/plugins":/plugins \
  --name neo4j-local neo4j:5.21.2
