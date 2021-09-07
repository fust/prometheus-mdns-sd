FROM ubuntu:focal

RUN export DEBIAN_FRONTEND=noninteractive \
  && apt update \
  && apt install --no-install-recommends -yq golang git ca-certificates \
  && groupadd prometheus-sd \
  && useradd -m -g prometheus-sd prometheus-sd \
  && mkdir /home/prometheus-sd/output \
  && chown -R prometheus-sd:prometheus-sd /home/prometheus-sd/output \
  && apt clean \
  && apt autoclean \
  && apt autoremove \
  && rm -rf /var/lib/apt/lists/*

USER prometheus-sd
WORKDIR /home/prometheus-sd

RUN go get github.com/msiebuhr/prometheus-mdns-sd \
  && go install github.com/msiebuhr/prometheus-mdns-sd

ENTRYPOINT ["/home/prometheus-sd/go/bin/prometheus-mdns-sd", "-out", "/home/prometheus-sd/output/mdns-sd.json"]
