FROM fpco/stack-build:lts-22.43 AS build

WORKDIR /opt/fitzbeach

COPY stack.yaml stack.yaml.lock fitzbeach-backend.cabal ./
COPY app app
COPY src src

RUN stack --stack-yaml stack.yaml --no-terminal build --copy-bins --local-bin-path /opt/fitzbeach/bin

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
