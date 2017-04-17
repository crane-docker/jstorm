FROM openjdk:8-jre-alpine

MAINTAINER crane "crane.liu@qq.com"
 
ENV TZ "Asia/Shanghai"
 
RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.4/main" > /etc/apk/repositories
 
# Install required packages
RUN apk add --no-cache --update\
    unzip \
    bash \
    python \
    su-exec

ARG JSTORM_VERSION=2.2.1
ARG DISTRO_NAME=jstorm-${JSTORM_VERSION}
ARG JSTORM_INSTALL_PATH=/opt
ENV JSTORM_HOME ${JSTORM_INSTALL_PATH}/jstorm
ENV PATH $PATH:$JSTORM_HOME/bin

ENV JSTORM_USER=jstorm \
    JSTORM_DATA_DIR=/jdata \
    JSTORM_LOG_DIR=/jlogs

# Add a user and make dirs
RUN set -x \
    && adduser -D "$JSTORM_USER" \
    && mkdir -p "$JSTORM_DATA_DIR" "$JSTORM_LOG_DIR" \
    && chown -R "$JSTORM_USER:$JSTORM_USER" "$JSTORM_DATA_DIR" "$JSTORM_LOG_DIR"


# copy Storm, untar and clean up
COPY file/${DISTRO_NAME}.zip /

RUN unzip "/${DISTRO_NAME}.zip" -d "${JSTORM_INSTALL_PATH}/" && \
    mv "${JSTORM_INSTALL_PATH}/${DISTRO_NAME}" "$JSTORM_HOME" && \
    mv "$JSTORM_HOME/conf/storm.yaml" "$JSTORM_HOME/conf/storm.yaml.template" && \
    chmod +x "$JSTORM_HOME/bin/jstorm" && \
    rm "/${DISTRO_NAME}.zip"

WORKDIR $JSTORM_HOME

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
