FROM mcr.microsoft.com/dotnet/sdk:6.0 AS retype

WORKDIR /build
COPY . /build

RUN dotnet tool install retypeapp --tool-path /bin
RUN retype build --output .docker-build/

FROM busybox:1.35

RUN adduser -D static
USER static
WORKDIR /home/static

COPY --from=retype /build/.docker-build/ .

CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]

