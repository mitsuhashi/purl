#!/bin/bash

cd purl_web_Dockerfile 
docker pull postgres:latest
docket build --tag rails_for_purl .

cd purl_db_Dockerfile
docker build --tag postgres_ja .
