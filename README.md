# groker
Dockerfile and resources for Grokit

## Building

To build Grokit on your local machine, first install [docker](https://www.docker.com/). Then, run 

```bash
docker build -t "grokit" .
```

## Running

To build and run a container out of the Groker image, run:

```bash
docker run -t -i groker /bin/bash
```

Once you are in, you can run R scripts in the Grokit environment in the following way:

```bash
mode=offline Rscript sampleQuery.R
```

`mode=offline` is important because it allows Grokit to run without trying to get relations from a server.
