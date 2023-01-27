#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/5_domain_infos.sql
