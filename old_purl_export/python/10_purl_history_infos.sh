#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from purl_history_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/10_purl_history_infos.sql
