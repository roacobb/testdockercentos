FROM ubuntu 
MAINTAINER Rodney Cobb <roacobb@gmail.com>


ENV SOLR_VERSION 3.6.0
ENV SOLR apache-solr-$SOLR_VERSION
ADD http://archive.apache.org/dist/lucene/solr/$SOLR_VERSION/$SOLR.tgz /opt/$SOLR.tgz
RUN tar -C /opt --extract --file /opt/$SOLR.tgz
RUN mv /opt/$SOLR /opt/solr

CMD ["/bin/bash", "-c", "cd /opt/solr/example; java -jar start.jar"]

EXPOSE 8983

FROM centos

RUN yum -y update

RUN yum -y groupinstall "Development Tools"
RUN yum -y install erlang gcc gcc-c++ kernel-devel-`uname -r` make perl sqlite-devel
RUN yum -y install bzip2 bzip2-devel zlib-devel
RUN yum -y install ncurses-devel readline-devel tk-devel
RUN yum -y install net-tools nfs-utils openssl-devel
RUN yum -y install git screen tmux wget zsh

RUN echo 'Defaults  secure_path=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin' >> /etc/sudoers.d

RUN /usr/bin/curl -s 'http://www.python.org/download/releases/' | gawk 'match($0, /The current production versions are <strong>([0-9.]+)<\/strong>/, ary) {print ary[1]}' > PYTHON$
RUN cat PYTHON_VERSION | { read VERSION; wget -O Python-${VERSION}.tar.xz http://python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz && tar -xf Python-${VERSION}.tar.xz; }
RUN cat PYTHON_VERSION | { read VERSION; cd Python-${VERSION} && ./configure --prefix=/usr/local && make && make altinstall; }
RUN rm -rf Python*
RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python

RUN /usr/bin/curl -O http://python-distribute.org/distribute_setup.py
RUN /usr/local/bin/python distribute_setup.py
RUN rm -rf distribute_setup.py
RUN easy_install pip
