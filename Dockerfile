FROM python:3.10

ENV ODBCINI=/opt/odbc.ini

ENV ODBCSYSINI=/opt/
ARG UNIXODBC_VERSION=2.3.12

RUN apt-get update && \
    apt-get install -y curl gzip tar gnupg openssl libssl-dev build-essential && \
    apt-get clean

RUN curl ftp://ftp.unixodbc.org/pub/unixODBC/unixODBC-${UNIXODBC_VERSION}.tar.gz -O \
    && tar xzvf unixODBC-${UNIXODBC_VERSION}.tar.gz \
    && cd unixODBC-${UNIXODBC_VERSION} \
    && ./configure --sysconfdir=/opt --disable-gui --disable-drivers --enable-iconv --with-iconv-char-enc=UTF8 --with-iconv-ucode-enc=UTF16LE --prefix=/opt \
    && make \
    && make install

# Install Microsoft ODBC driver for SQL Server (Debian-based package)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql18

RUN echo $'[ODBC Driver 18 for SQL Server]\nDriver = ODBC Driver 18 for SQL Server\nDescription = My ODBC Driver 18 for SQL Server\nTrace = No' > /root/odbc.ini
RUN echo $'[ODBC Driver 18 for SQL Server]\nDescription = Microsoft ODBC Driver 18 for SQL Server\nDriver = /opt/microsoft/msodbcsql18/lib64/libmsodbcsql-18.2.so.2.1\nUsageCount = 1' > /root/odbcinst.ini

ENV CFLAGS="-I/opt/include"
ENV LDFLAGS="-L/opt/lib"

# RUN pip install pyodbc
