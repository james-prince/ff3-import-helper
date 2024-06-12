FROM golang:alpine AS build
RUN apk update && apk add ca-certificates
WORKDIR /app
ADD . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -tags timetzdata -o ff3-import-helper

FROM scratch AS final
COPY --from=build /app/ff3-import-helper /
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENV TZ 'Etc/UTC'
ENV CRON_SCHEDULE '@midnight'
ENV GOTIFY_PRIORITY 5
ENTRYPOINT ["/ff3-import-helper"]