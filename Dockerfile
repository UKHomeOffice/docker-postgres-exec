FROM quay.io/ukhomeofficedigital/postgres:v0.1.0

ENV TERM dumb

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
