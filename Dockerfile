FROM docker.io/library/ubuntu:26.04
RUN apt-get update && \
    apt-get install -y --no-install-recommends bind9 bind9utils && \
    rm -rf /var/lib/apt/lists/*
RUN rm -f /usr/bin/pebble
COPY named.conf.options /etc/bind/
COPY named.conf.local /etc/bind/
RUN chown root:bind /etc/bind/named.conf.options /etc/bind/named.conf.local && \
    chmod 644 /etc/bind/named.conf.options /etc/bind/named.conf.local
EXPOSE 53/tcp 53/udp
CMD ["/usr/sbin/named", "-g", "-c", "/etc/bind/named.conf"]
## File edit to confirm polling works
