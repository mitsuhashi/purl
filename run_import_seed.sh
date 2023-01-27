#!/bin/bash

docker exec -it purl_web_apache /bin/bash -c "export PATH=/usr/local/rbenv/shims:/usr/local/rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin; bundle exec rake db:seed"
