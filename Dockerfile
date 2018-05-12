FROM python:3.6-alpine3.7
LABEL maintainer="3it@terminal1.co"

ARG SUPERSET_VERSION=0.25.0

# Add superset_config.py folder to PYTHONPATH so superset could find it.
ENV PYTHONPATH=/etc/superset:$PYTHONPATH \
    SUPERSET_HOME=/opt/superset \
    SUPERSET_VERSION=${SUPERSET_VERSION}

RUN adduser -S -H superset && \
    mkdir -p /etc/superset && chown -R superset /etc/superset && \
    mkdir -p /opt/superset && chown -R superset /opt/superset && \
    apk add --no-cache --virtual .meta-build-dependencies \
        cyrus-sasl-dev \
        g++ \
        gcc \
        libffi-dev \
        libressl-dev \
        musl-dev \
        postgresql-dev \
        python3-dev && \
    apk add --no-cache libpq && \
    pip3 install --no-cache-dir --no-build-isolation \
        Flask==0.12.4 \
        SQLAlchemy-Utils==0.32.21 && \
    pip3 install --no-cache-dir --no-build-isolation \
        gevent==1.2.2 \
        psycopg2==2.7.4 \
        redis==2.10.6 \
        superset==${SUPERSET_VERSION} && \
    apk del .meta-build-dependencies && \
    find / -type d -name __pycache__ -exec rm -r {} + && \
    find /usr/local/lib/python3.6/site-packages -type d -name tests -exec rm -r {} + && \
    rm -rf \
        /root/.cache \
        /usr/share/terminfo \
        /var/cache

EXPOSE 8088
CMD ["gunicorn", "--workers=10", "--worker-class=gevent", "--timeout=120", "--bind=0.0.0.0:8088", "--limit-request-line=0", "--limit-request-field_size=0", "superset:app"]
USER superset
