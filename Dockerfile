FROM python:3.7-alpine
LABEL maintainer="Kelton Karboviak <kelton.karboviak@gmail.com>"

COPY Pipfile* ./

RUN apk add --no-cache --virtual .prod-deps \
        libxslt-dev \
    && apk add --no-cache --virtual .build-deps \
        build-base \
        libffi-dev \
        libxml2-dev \
        openssl-dev \
    # Install python dependencies
    && pip3 install --upgrade pip pipenv \
    && pipenv check \
    && pipenv install --deploy --system \
    # Clean up
    && apk del -v --purge \
        .build-deps \
    && pip uninstall -y pipenv virtualenv virtualenv-clone \
    && rm -rf \
        /var/cache/apk/* \
        /root/.cache/pip/* \
        /root/.cache/pipenv/*

VOLUME [ "/root/.aws" ]
