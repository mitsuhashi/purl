#!/bin/bash
SUF=`date "+%Y%m%d%H%M%S"`
FILENAME="purl_dev_"$SUF".dmp"
BKUPDIR="."
docker exec -it purl_db pg_dump -a -d purl_dev -U postgres > "$BKUPDIR/$FILENAME"
