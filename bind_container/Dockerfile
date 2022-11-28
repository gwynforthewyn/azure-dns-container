FROM ubuntu/bind9
COPY files/named.conf.options /etc/bind/named.conf.options

RUN apt-get update && apt-get install -y dnsutils bind9utils vim
