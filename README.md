# decode-system-test

This repo will contain a docker-compose config linking together the components
developed for the DECODE IoT pilot, demonstrating how they can work together in
order to provide the proposed functionality.

## Requirements

* Docker (with compose) - recent build
* make (not required, but convenient at least on Linux/OSX)

## Running the components

To run the components you should just be able to run:

```bash
$ make start
```

This should pull and start all components running, with some logic to ensure
all required databases within Postgres are created, and that services wait for
Postgres to be ready before they try and run.

Note this is just a convenience helper for `docker-compose up` here.

Or to clean everything:

```bash
$ make teardown
```

This final command should remove all components including volumes and networks.

If you do not have `make` available, you can run all services directly provided
you have `docker-compose` available.

To start manually:

```bash
$ docker-compose up
```

## Services

Once everything has started you should have the following components running:

* The IoT datastore (listening on http://localhost:8080)
* The IoT encoder (listening on http://localhost:8081)
* The IoT policystore (listening on http://localhost:8082)
* Prometheus (listening on http://localhost:9090)
* Grafana (listening on http://localhost:3000)
* Web demo service (listening on https://localhost:4001) - note this service
  runs over TLS with a self signed certificate which will case scary warnings.
  This is to support a library which captures the webcam for QR code scanning.

## Component Configuration

### Datastore

The binary generated for this application is called `iotstore`. It has the following four subcommands:

* `delete` - can be used to delete old data from the database
* `help` - displays help informmation
* `migrate` - allows database migrations to be created and applied
* `server` - the primary command that starts up the server.

For operational use the `server` command is the only one that is generally
required.

**Configuration for `server` command**

| Flag                 | Environment Variable  | Description                                      | Default value | Required |
| -------------------- | --------------------- | ------------------------------------------------ | ------------- | -------- |
| --addr or -a         | IOTSTORE_ADDR         | The address to which the server binds            | 0.0.0.0:8080  | No       |
| --cert-file or -c    | IOTSTORE_CERT_FILE    | The path to a TLS certificate file to enable TLS |               | No       |
| --key-file or -k     | IOTSTORE_KEY_FILE     | The path to a TLS key file to enable TLS         |               | No       |
| --verbose            | IOTSTORE_VERBOSE      | Flag that if set enables verbose mode            | False         | No       |
| --database-url or -d | IOTSTORE_DATABASE_URL | Connection string for Postgres database          |               | Yes      |

### Encoder

The binary generated for this application is called `iotenc`. It has the following four subcommands:

* `help` - displays help informmation
* `migrate` - allows database migrations to be created and applied
* `server` - the primary command that starts up the server.

For operational use the `server` command is the only one that is generally
required.

**Configuration for `server` command**

| Flag                  | Environment Variable           | Description                                                 | Default value                   | Required |
| --------------------- | ------------------------------ | ----------------------------------------------------------- | ------------------------------- | -------- |
| --addr or -a          | IOTENCODER_ADDR                | The address to which the server binds                       | 0.0.0.0:8081                    | No       |
| --broker-addr or -b   | IOTENCODER_BROKER_ADDR         | Address at which the MQTT broker is listening               | tcp://mqtt.smartcitizen.me:1883 | No       |
| --cert-file or -c     | IOTENCODER_CERT_FILE           | The path to a TLS certificate file to enable TLS            |                                 | No       |
| --database-url        | IOTENCODER_DATABASE_URL        | Connection string for Postgres database                     |                                 | Yes      |
| --datastore or -d     | IOTENCODER_DATASTORE           | Address at which the datastore component is listening       |                                 | Yes      |
| --encryption-password | IOTENCODER_ENCRYPTION_PASSWORD | Password used to encrypt secret tokens we write to Postgres |                                 | Yes      |
| --hashid-length or -l | IOTENCODER_HASHID_LENGTH       | Minimum length of generated ids for streams                 | 8                               | No       |
| --hashid-salt         | IOTENCODER_HASHID_SALT         | Salt value used for generating ids for streams              |                                 | Yes      |
| --key-file or -k      | IOTENCODER_KEY_FILE            | The path to a TLS key file to enable TLS                    |                                 | No       |
| --redis-url           | IOTENCODER_REDIS_URL           | URL at which Redis is listening                             |                                 | Yes      |
| --verbose             | IOTENCODER_VERBOSE             | Flag that if set enables verbose mode                       | False                           | No       |
|                       | SENTRY_DSN                     | Optional DSN string for Sentry error reporting              |                                 | No       |

### Policystore

# Configuration

The binary generated for this application is called `policystore`. It has the
following four subcommands:

* `help` - displays help informmation
* `migrate` - allows database migrations to be created and applied
* `server` - the primary command that starts up the server.

For operational use the `server` command is the only one that is generally
required.

**Configuration for `server` command**

| Flag                  | Environment Variable            | Description                                  | Default value | Required |
| --------------------- | ------------------------------- | -------------------------------------------- | ------------- | -------- |
| --addr or -a          | POLICYSTORE_ADDR                | The address to which the server binds        | 0.0.0.0:8082  | No       |
| --cert-file or -c     | POLICYSTORE_CERT_FILE           | Path to a TLS certificate file to enable TLS |               | No       |
| --database-url or -d  | POLICYSTORE_DATABASE_URL        | URL at which Postgres is listening           |               | Yes      |
| --encryption-password | POLICYSTORE_ENCRYPTION_PASSWORD | Password used to encrypt secrets in the DB   |               | Yes      |
| --hashid-length or -l | POLICYSTORE_HASHID_LENGTH       | Minimum length of generated IDs              | 8             | No       |
| --hashid-salt         | POLICYSTORE_HASHID_SALT         | Salt value used when generating IDs          |               | Yes      |
| --key-file or -k      | POLICYSTORE_KEY_FILE            | Path to a TLS key file to enable TLS         |               | No       |