FROM alpine:3.10

ENV AWSCLI_VERSION "1.18.221"

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    && pip install awscli==$AWSCLI_VERSION --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*

ENV ORG_PREFIX lemonenergy
ENV REPOSITORY_LAYER ''
ENV IS_A_PACKAGE false
ENV IS_DEPLOYMENT_ROLLBACK false

ENV CONTAINER_AWS_REGION us-east-2

ENV EVENT_SOURCE event-source
ENV EVENT_BUS_NAME_PREFIX event-bus
ENV EVENT_NAME serviceDeployed

ENV GITHUB_REPOSITORY ''
ENV GITHUB_SHA ''

ENV AWS_ACCESS_KEY_ID ''
ENV AWS_SECRET_ACCESS_KEY ''

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["prod"]