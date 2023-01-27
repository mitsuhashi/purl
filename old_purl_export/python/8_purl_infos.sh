#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/8_purl_infos.sql
