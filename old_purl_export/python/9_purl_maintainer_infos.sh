#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/9_purl_maintainer_infos.sql
