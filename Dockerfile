FROM node:20-slim AS retype

WORKDIR /build
COPY . .

RUN npm install --global retypeapp
RUN retype build --output .docker-build/

FROM busybox:1.35

RUN adduser -D static
USER static
WORKDIR /home/static

COPY --from=retype /build/.docker-build/ .

CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]

