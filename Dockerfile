FROM python:2.7.16-alpine

ENV PS1="\[\033[01;34m\]\u(docker)\[\033[0m\] @ \[\033[01;32m\]\W\[\033[0m\] > "

ENV BUILD_PACKAGES="build-base git ca-certificates gcc"                                                       \
    DEVELOPMENT_PACKAGES="curl bash netcat-openbsd"                                                           \
    THUMBOR_PACKAGES="libcurl libjpeg-turbo openjpeg libwebp tiff"                                            \
    THUMBOR_DEV_PACKAGES="curl-dev libjpeg-turbo-dev openjpeg-dev libwebp-dev tiff-dev libressl-dev musl-dev" \
    GRAPHVIZ_PACKAGES="graphviz font-bitstream-type1"

WORKDIR /thumbor

COPY ./thumbor /thumbor

RUN apk update                                                                                        && \
    apk upgrade                                                                                       && \
    apk add --update $BUILD_PACKAGES                                                                  && \
    apk add --update $DEVELOPMENT_PACKAGES $THUMBOR_PACKAGES $THUMBOR_DEV_PACKAGES $GRAPHVIZ_PACKAGES && \
    rm -rf /var/cache/apk/*                                                                           && \
    pip install --no-cache-dir -r requirements.txt                                                    && \
    apk del gcc *-dev                                                                                 && \
    rm -rf /var/cache/apk/*                                                                           && \
    rm -rf /root/.cache

CMD "./run.sh"
