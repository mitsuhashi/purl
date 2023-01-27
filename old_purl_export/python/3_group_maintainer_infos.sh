#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from group_maintainer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/3_group_maintainer_infos.sql
