FROM alpine:latest
MAINTAINER Mathias Beugnon <mathias@beugnon.fr>
LABEL com.resilio.version="2.4.0" \
  org.label-schema.vcs-url="https://github.com/oomathias/resilio-sync"

RUN apk --no-cache --update add \
  curl \
  tar \
  wget \
  bash \
  grep

# add dumb-init
RUN curl -s https://api.github.com/repos/Yelp/dumb-init/releases \
  | grep browser_download_url | grep amd64 | head -n 1 | cut -d '"' -f 4 | \
  wget -q -i - -O /usr/local/bin/dumb-init \
  && chmod +x /usr/local/bin/dumb-init

# add glibc
RUN curl -s https://api.github.com/repos/sgerrand/alpine-pkg-glibc/releases \
  | grep browser_download_url | grep .apk | grep -v unreleased | grep -v bin | grep -v i18n \
  | head -n 1 | cut -d '"' -f 4 | \
  wget -q -i - -O glibc.apk \
  && apk add --allow-untrusted glibc.apk \
  && rm -r glibc.apk

# add resilio-sync
RUN curl https://download-cdn.resilio.com/stable/linux-glibc-x64/resilio-sync_glibc23_x64.tar.gz | tar xvzf - \
  && mv rslsync /usr/local/bin \
  && chmod +x /usr/local/bin/rslsync

RUN apk del --no-cache curl tar wget bash grep \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && rm -r /root/.wget-hsts

ADD entrypoint.sh /
ADD sync.conf /etc/
RUN chmod +x /entrypoint.sh

VOLUME /mnt/sync

ENTRYPOINT ["/usr/local/bin/dumb-init", "/entrypoint.sh"]
CMD ["--log", "--config", "/etc/sync.conf"]
