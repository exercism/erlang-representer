FROM hexpm/erlang:22.3.4.12-ubuntu-focal-20200703 as ERLANG

ENV REBAR_VSN=3.14.1
ENV TOOL_WS_VSN=0.11.0

FROM ERLANG as DOWNLOADER

RUN set -ex; \
  apt update; \
  apt install --yes curl; \
  rm -rf /var/lib/apt/lists/*

RUN set -ex; \
  curl -L -o /usr/local/bin/rebar3 \
    https://github.com/erlang/rebar3/releases/download/${REBAR_VSN}/rebar3; \
  curl -L -o /usr/local/bin/tooling_webserver \
    https://github.com/exercism/tooling-webserver/releases/download/${TOOL_WS_VSN}/tooling_webserver; \
  chmod +x /usr/local/bin/*

FROM ERLANG as BUILDER

COPY --from=DOWNLOADER /usr/local/bin/rebar3 /usr/local/bin/rebar3

RUN mkdir -p /build

COPY . /build

RUN set -ex; \
  cd /build; \
  chmod +x run.sh; \
  rebar3 escriptize

FROM ERLANG as TARGET

label maintainer="timmelzer@gmail.com"

COPY --from=DOWNLOADER /usr/local/bin/tooling_webserver /usr/local/bin/tooling_webserver

COPY --from=BUILDER /build/_build/default/bin/erl_representer /usr/local/bin/erl_representer
COPY --from=BUILDER /build/run.sh /usr/local/bin/run.sh

ENTRYPOINT [ "/usr/local/bin/run.sh" ]
