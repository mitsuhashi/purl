fROM debian

RUN apt-get update && \
    apt-get install -y python3 \
                       python3-pip \
                       python3-numpy python3-matplotlib \
                       python3-tk \
                       vim \
                       less \
                       tcsh \
                       --no-install-recommends && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    mkdir -p /etc/sudoers.d && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer

RUN apt-get install -y python3-dev build-essential python3-setuptools swig && \
    pip3 install bcrypt

#Japanese 
RUN apt-get install -y locales 
RUN echo "ja_JP.UTF-8 UTF-8" > /etc/locale.gen && \ 
    locale-gen ja_JP.UTF-8 && \
    #dpkg-reconfigure locales && \
    /usr/sbin/update-locale LANG=ja_JP.UTF-8 
ENV LC_ALL ja_JP.UTF-8 
ENV LANG ja_JP.UTF-8 
ENV LC_CTYPE ja_JP.UTF-8 
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

#Change default python's version
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/python3-config /usr/bin/python-config && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

#ODBC
RUN apt-get install -y unixodbc libaio1 libaio-dev python3-pyodbc zip

#ODBC for postgres
RUN apt-get install -y unixodbc-bin unixodbc-dev odbc-postgresql

#MySQL
COPY mysql-connector-odbc-8.0.15-linux-glibc2.12-x86-64bit.tar.gz /tmp/
RUN cd /tmp && \
    tar xf mysql-connector-odbc-8.0.15-linux-glibc2.12-x86-64bit.tar.gz && \
    cp /tmp/mysql-connector-odbc-8.0.15-linux-glibc2.12-x86-64bit/lib/* /usr/lib/x86_64-linux-gnu/odbc/ && \ 
    echo "" >> /etc/odbcinst.ini && \
    echo "[MySQL]" >> /etc/odbcinst.ini && \
    echo "Description=MySQL driver" >> /etc/odbcinst.ini && \
    echo "Driver=libmyodbc8a.so" >> /etc/odbcinst.ini && \
    echo "Debug=0" >> /etc/odbcinst.ini && \
    echo "CommLog=1" >> /etc/odbcinst.ini && \
    echo "UsageCount=1" >> /etc/odbcinst.ini
