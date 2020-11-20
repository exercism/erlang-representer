FROM hexpm/erlang:22.3.4.12-alpine-3.12.0 as ERLANG

FROM ERLANG as BUILDER

# prepare the build environment
RUN apk add --no-cache curl; \
  mkdir -p /build; \
  mkdir -p /tmp

# Download additional required tools
RUN set -ex; \
  curl -L -o /usr/local/bin/rebar3 \
    https://github.com/erlang/rebar3/releases/download/3.14.2/rebar3; \
  curl -L -o /usr/local/bin/tooling_webserver \
    https://github.com/exercism/tooling-webserver/releases/download/0.11.0/tooling_webserver; \
  chmod +x /usr/local/bin/*

COPY . /build

RUN set -ex; \
  cd /build; \
  rebar3 escriptize

FROM ERLANG as TARGET

label maintainer="timmelzer@gmail.com"

COPY --from=BUILDER /build/_build/default/bin/erl_representer /usr/local/bin/erl_representer
COPY --from=BUILDER /usr/local/bin/tooling_webserver /usr/local/bin/tooling_webserver

ENTRYPOINT [ "/usr/local/bin/erl_representer" ]
