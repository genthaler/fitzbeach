FROM haskell:9.6.6 AS build

WORKDIR /opt/fitzbeach

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        libffi-dev \
        libgmp-dev \
        pkg-config \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

COPY fitzbeach-backend.cabal ./
RUN cabal update

COPY app app
COPY src src
COPY test test

RUN cabal install exe:fitzbeach-backend \
    --install-method=copy \
    --installdir=/opt/fitzbeach/bin \
    --overwrite-policy=always

FROM public.ecr.aws/awsguru/aws-lambda-adapter:0.9.1 AS adapter

FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        libffi8 \
        libgmp10 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

COPY --from=adapter /lambda-adapter /opt/extensions/lambda-adapter
COPY --from=build /opt/fitzbeach/bin/fitzbeach-backend /var/task/fitzbeach-backend

ENV AWS_LWA_PORT=8080
ENV APP_ENABLE_CORS=false
ENV PORT=8080

CMD ["/var/task/fitzbeach-backend"]
