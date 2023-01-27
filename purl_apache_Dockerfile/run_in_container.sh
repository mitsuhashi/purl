#!/bin/bash

ruby_version=2.6.0
rails_version=5.2.2

passenger_ver=`ls /usr/local/rbenv/versions/${ruby_version}/lib/ruby/gems/${ruby_version}/gems |grep passenger`

cd /opt/rails_${rails_version}/purl
source /root/.bashrc
bundle install
sed -i "s#x.x.x/lib/ruby/gems/x.x.x/gems/passenger-x.x.x#${ruby_version}/lib/ruby/gems/${ruby_version}/gems/${passenger_ver}#g" /etc/httpd/conf/httpd.conf
apachectl -D FOREGROUND
