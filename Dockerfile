FROM amazonlinux:latest
RUN yum -y update
RUN yum -y install tar gzip make automake gcc gcc-c++ kernel-devel cmake openssl-devel libssh2-devel libcurl-devel git wget
RUN cd /root && \
      git clone --depth 10 --single-branch --branch mbedtls-2.6.1 https://github.com/ARMmbed/mbedtls.git mbedtls && \
      cd mbedtls && \
      CFLAGS=-fPIC cmake -DENABLE_PROGRAMS=OFF -DENABLE_TESTING=OFF -DUSE_SHARED_MBEDTLS_LIBRARY=OFF -DUSE_STATIC_MBEDTLS_LIBRARY=ON . && \
      cmake --build . && \
      make install
RUN cd /root && \
      wget https://github.com/libgit2/libgit2/archive/v0.27.8.tar.gz && \
      tar xvf v0.27.8.tar.gz && \
      cd libgit2-0.27.8 && \
      cmake . && \
      make && \
      make install

RUN yum -y install python3 python3-devel
RUN pip3 install cffi
RUN pip3 install pygit2
RUN echo /usr/local/lib > /etc/ld.so.conf.d/libgit2.conf
RUN ldconfig

RUN python3 -c 'import pygit2'

RUN cd /root && \
    wget https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-amazon2-4.0.6.tgz && \
    tar xvf mongodb-linux-x86_64-amazon2-4.0.6.tgz

RUN mkdir /root/data

EXPOSE 27017
COPY entrypoint.sh /root/entrypoint.sh
ENTRYPOINT [ "/bin/bash", "/root/entrypoint.sh"]
