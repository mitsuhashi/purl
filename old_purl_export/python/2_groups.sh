#!/bin/bash

docker exec -it purl_db psql -U postgres -d purl_dev -f /tmp/2_groups.sql
