FROM mikaak/elixir-node:1.10-alpine as builder

WORKDIR /home

# Add mix files
COPY ./config/* ./config/
COPY ./mix.exs ./

ENV HEX_HTTP_CONCURRENCY=4 \
    HEX_HTTP_TIMEOUT=500 \
    MIX_ENV=prod \
    NODE_ENV=production \
    PORT=4000

RUN mix do deps.get, compile

COPY ./assets/package.json ./assets/
COPY ./assets/package-lock.json ./assets/
RUN NODE_ENV=development npm install --progress=false --no-audit --loglevel=error --prefix ./assets

COPY ./lib ./lib
COPY ./assets assets

# Install Deps and Release
RUN mkdir -p priv/static && npm run deploy --prefix assets/ && mix phx.digest && rm -rf deps/*/.git && mix release

FROM mikaak/elixir:1.10-alpine

WORKDIR /root
COPY --from=builder /home/_build/prod/learn_elixir_landing-0.1.0.tar.gz ./
RUN ["tar", "xzf", "learn_elixir_landing-0.1.0.tar.gz"]

ENV PORT=4000

EXPOSE 4000

ENTRYPOINT ["/root/bin/learn_elixir_landing"]
CMD ["start"]
