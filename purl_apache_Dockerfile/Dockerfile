from centos:7.7.1908

#「rbenv install --list」コマンドで指定できるバージョンを確認
ARG ruby_version="2.6.0"
#「gem query -ra -n "^rails$"」コマンドで指定できるバージョンを確認
ARG rails_version="5.2.2"
# プロジェクト名
ARG project="purl"

RUN yum update -y && \
    yum install -y git && \
    yum install -y bzip2 gcc openssl-devel readline-devel zlib-devel gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel sqlite-devel && \
    yum install -y make autoconf curl wget && \
    yum install -y postgres postgresql-devel && \
    yum install -y httpd && \
    yum install -y libcurl-develop httpd-devel gcc-c++ && \
    yum install -y libcurl-devel

RUN cd /tmp/ && \
    git clone https://github.com/rbenv/rbenv.git /usr/local/rbenv && \
    git clone https://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build && \
    export RBENV_ROOT=/usr/local/rbenv && \
    export PATH="/usr/local/rbenv/bin:$PATH" && \
    eval "$(rbenv init -)" && \
    echo 'PATH="/usr/local/rbenv/bin:$PATH"' >> /root/.bashrc && \
    echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> /root/.bashrc && \
    rbenv install ${ruby_version} && \
    rbenv global ${ruby_version} && \
    gem install bundler && \
    mkdir /opt/rails_${rails_version} && \
    cd /opt/rails_${rails_version}/ && \
    bundle init && \
    echo "gem \"rails\", \"${rails_version}\"" >> Gemfile && \ 
    #gemパッケージは/opt/rails_<version>/vendor/bundle以下にインストールされる
    bundle install --path vendor/bundle && \
    #以下のbundler-exec.shをsourceコマンドで読み込めばrailsコマンドを実行する際にbundle exec railsとする必要がなくなる
    #curl -L https://github.com/gma/bundler-exec/raw/master/bundler-exec.sh > bundler-exec.sh && \
    #sed -i 's/wagon/wagon\nrails/g' bundler-exec.sh && \
    #source bundler-exec.sh && \
    bundle exec rails new ${project} --skip-bundle && \
    gem install passenger && \
    passenger-install-apache2-module -a && \
    chown -R apache.apache /usr/local/rbenv

COPY httpd.conf /etc/httpd/conf/httpd.conf
COPY run_in_container.sh /run_in_container.sh

RUN chmod +x /run_in_container.sh

CMD ["/run_in_container.sh"]
