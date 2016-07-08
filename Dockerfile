FROM quay.io/ukhomeofficedigital/postgres:v0.0.2

ENV TERM dumb

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
