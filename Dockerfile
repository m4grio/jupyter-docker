FROM alpine:3.6
LABEL maintainer="ahoy@m4grio.me"

USER root

# Python and dependences
RUN \
    set -xe ;\
    apk add --no-cache \
        python3

# Ensure pip is present
RUN \
    set -xe ;\
    python3 -m ensurepip

# Main jupyter dependencies
RUN \
    set -xe ;\
    apk add --no-cache \
        gcc \
        libzmq \
        py3-zmq \
        py3-tornado

RUN \
    set -xe ;\
    pip3 install --upgrade pip ;\
    pip3 install jupyter

# Configure environment
# https://commons.wikimedia.org/wiki/File:Holst_The_Planets_Jupiter.ogg
ENV NOTEBOOK_USER   gustav
ENV NOTEBOOK_GROUP  holst
ENV NOTEBOOK_UID    1000
ENV NOTEBOOK_GID    1000
ENV NOTEBOOK_DIR    /opt/notebook
ENV LC_ALL          en_US.UTF-8
ENV LANG            n_US.UTF-8
ENV LANGUAGE        en_US.UTF-8

WORKDIR ${NOTEBOOK_DIR}
VOLUME $NOTEBOOK_DIR

RUN addgroup $NOTEBOOK_GROUP
RUN adduser \
    -D \
    -s /bin/sh \
    -G $NOTEBOOK_GROUP \
    -u $NOTEBOOK_UID $NOTEBOOK_USER
RUN chown -R gustav:holst $NOTEBOOK_DIR

RUN apk add --no-cache tini

EXPOSE 8888

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["jupyter-notebook", "--ip=0.0.0.0", "--port=8888"]

USER $NOTEBOOK_USER
