DMP_FILE="purl_dev_20200207171015.dmp"

docker exec -it purl_db psql -U postgres -c "drop database purl_dev;"
docker exec -it purl_db psql -U postgres -c "create database purl_dev;"

../../run_migrate_in_host.sh

docker cp ${DMP_FILE} purl_db:/tmp/
docker exec -it purl_db /bin/bash -c "psql -U postgres purl_dev < /tmp/${DMP_FILE}"
