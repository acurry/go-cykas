# go-cykas

A web-service to create destructible notes. 

* Create note via web service. TTL can be configured as a duration, or to be destroyed
on GET request
* Fully anonymized.
* TLS supported
* All notes are stored as encrypted at rest.

## Requirements

* Docker & docker-compose
* A text editor
* A terminal app

### self-signed TLS cert

```
go run $GOPATH/../go/src/crypto/tls/generate_cert.go --rsa-bits=4096 --host=localhost
```

### db password generation

```
openssl rand -hex 64
```

### hey

[`hey`](https://github.com/rakyll/hey) is a tool to send loads to a web app.

```sh
$ brew install hey
```
