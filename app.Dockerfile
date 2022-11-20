FROM golang:latest

WORKDIR /go/src/app/
ADD . .

RUN go mod download -x
RUN go install github.com/githubnemo/CompileDaemon@latest
RUN go install honnef.co/go/tools/cmd/staticcheck@latest

WORKDIR /go/bin

EXPOSE 4000

WORKDIR /go/src/app
RUN go build -o ./bin/main ./cmd/api

ENTRYPOINT CompileDaemon -build="go build -o ./bin/main ./cmd/api" -command="./bin/main"