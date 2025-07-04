FROM golang:1.22.5 AS base
WORKDIR /app
COPY go.mod ./
RUN go mod download
COPY . .
RUN go build -o main .

# Cross-compile for linux amd64 explicitly
RUN GOOS=linux GOARCH=amd64 go build -o main .

FROM gcr.io/distroless/base 
COPY --from=base /app/main .
COPY --from=base /app/static ./static
EXPOSE 8080
CMD [ "./main" ]


