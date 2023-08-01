FROM python:3.10.9-slim-buster as builder

ENV ODBCINI=/opt/odbc.ini
ENV ODBCSYSINI=/opt/
ARG UNIXODBC_VERSION=2.3.11

RUN yum install -y gzip tar gnupg openssl-devel && yum groupinstall "Development Tools" -y

RUN curl ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-${UNIXODBC_VERSION}.tar.gz -O \
    && tar xzvf unixODBC-${UNIXODBC_VERSION}.tar.gz \
    && cd unixODBC-${UNIXODBC_VERSION} \
    && ./configure --sysconfdir=/opt --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE --prefix=/opt \
    && make \
    && make install

RUN curl https://packages.microsoft.com/config/rhel/7/prod.repo > /etc/yum.repos.d/mssql-release.repo
RUN yum install e2fsprogs.x86_64 0:1.43.5-2.43.amzn1 fuse-libs.x86_64 0:2.9.4-1.18.amzn1 libss.x86_64 0:1.43.5-2.43.amzn1 -y
RUN ACCEPT_EULA=Y yum install -y msodbcsql18
RUN ACCEPT_EULA=Y yum install -y mssql-tools18

ENV CFLAGS="-I/opt/include"
ENV LDFLAGS="-L/opt/lib"

RUN mkdir /opt/python/ && cd /opt/python/ && pip install pyodbc -t .

#build layer with Docker and Terraform
FROM registry.gitlab.com/gitlab-org/terraform-images/stable:latest

COPY --from=builder /opt/python /opt/python
COPY --from=builder /opt/microsoft /opt/microsoft
COPY --from=builder /opt/lib /opt/lib