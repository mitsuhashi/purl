#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/4_group_infos.sql
