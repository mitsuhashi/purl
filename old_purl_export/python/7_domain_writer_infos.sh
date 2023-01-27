#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -c "delete from domain_writer_infos;"
docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/7_domain_writer_infos.sql
