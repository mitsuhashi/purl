#!/bin/bash

PORT=13000
NAME="purl_web"

#docker run --rm -d -it -p ${PORT}:3000 -v $PWD/contents:/opt/rails_5.2.2/purl -w /opt/rails_5.2.2/purl --name ${NAME} rails_for_purl bash
docker run --rm -d -it -p ${PORT}:3000 -w /opt/rails_5.2.2/purl --name ${NAME} rails_for_purl bash
#docker run --name purl_db -v $PWD/data:/var/lib/postgresql/data -e POSTGRES_PASSWORD=irjwtYAh7u@Wejo -e POSTGRES_INITDB_ARGS="--encoding=UTF-8 --locale=C" -d postgres_ja
#docker run --name purl_db -e POSTGRES_PASSWORD=irjwtYAh7u@Wejo -e POSTGRES_INITDB_ARGS="--encoding=UTF-8 --locale=C" -d postgres_ja
