FROM eclipse-temurin:11-jdk-alpine
#FROM --platform=linux/x86_64 eclipse-temurin:11-jdk-alpine

COPY docker/.ssh/ucb_judge_configurations /root/.ssh/
COPY docker/.ssh/config /root/.ssh/

RUN apk update;  \
    apk --no-cache add curl;  \
    apk add openssh;  \
    chmod 600 /root/.ssh/ucb_judge_configurations

EXPOSE 8888

VOLUME /tmp

ENV CONFIG_SERVER_USER="CONFIG_SERVER_USER"
ENV CONFIG_SERVER_PASSWORD="CONFIG_SERVER_PASSWORD"

ENV ZIPKIN_SERVER_URI="ZIPKIN_SERVER_URI"

ENV GIT_REPO_URI="GIT_REPO_URI"
ENV HOST_KEY="HOST_KEY"
ENV PRIVATE_KEY_PATH="PRIVATE_KEY_PATH"
ENV ENCRYPT_KEY="ENCRYPT_KEY"

ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","com.ucbjudge.configserver.ConfigServerApplicationKt"]