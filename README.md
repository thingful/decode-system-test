# decode-system-test

This repo will contain a docker-compose config linking together the components
developed for the DECODE IoT pilot, demonstrating how they can work together in
order to provide the proposed functionality.

Currently this repo only contains the datastore, but soon we will add the other
components being developed for evolution 1 of the system.

## Running the components

To run the components you should just be able to run:

```bash
$ make start
```

This should pull and start all components running, with some logic to ensure
all required databases within Postgres are created, and that services wait for
Postgres to be ready before they try and run.

Pressing Ctrl+C should then shut things down, but if you need to explicitly
stop services, then you can run:

```bash
$ make stop
```

Or to clean everything:

```bash
$ make teardown
```

This final command should remove all components including volumes and networks.
