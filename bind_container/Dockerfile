FROM ubuntu/bind9

COPY files/named.conf.options /etc/bind/named.conf.options
COPY files/named.conf.local /etc/bind/named.conf.local
COPY files/private_azure_pt_io.zone /etc/bind/private_azure_pt_io.zone

RUN apt-get update && apt-get install -y dnsutils bind9utils vim
