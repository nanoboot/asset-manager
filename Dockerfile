## Stage 1 (building)
# Compile sources and create the final application artifacts
FROM maven:3.9.1-amazoncorretto-19-debian-bullseye as builder

WORKDIR /usr/src

COPY . .
RUN mvn -Dmaven.test.skip=true \ 
        -f ./pom.xml clean install

## Stage 2 (Tomcat server)
# Copy application artifacts and Tomcat configuration files
FROM amazoncorretto:19.0.2

RUN mkdir -p /usr/local/tomcat/webapps
COPY --from=builder /usr/src/asset-manager-web/target/*.war /usr/local/tomcat/webapps/asset-manager.war

COPY --from=builder /usr/src/entrypoint.sh /usr/local/entrypoint.sh

RUN echo `java -version`


ARG TAG_VERSION="0.0.0-SNAPSHOT"
ARG TAG_BUILD="000"
ARG TAG_COMMIT="NOT DEFINED"
ARG BUILD_DATE="NOT DEFINED"

LABEL COMMIT=$TAG_COMMIT
LABEL Version=$TAG_VERSION
LABEL maintainer="robertvokac@nanoboot.org"


ENV TAG_COMMIT=$TAG_COMMIT
ENV ASI=$ASI
ENV BUILD_DATE=$BUILD_DATE
ENV TAG_VERSION=$TAG_VERSION
ENV TAG_BUILD=$TAG_BUILD

EXPOSE 8080
CMD ["sh", "/usr/local/entrypoint.sh", "2>&1"]
