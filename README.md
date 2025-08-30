# Docker images for YAML Runtimes

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/yaml/yaml-runtimes)


* [Quickstart](#Quickstart)
* [Dependencies](#Dependencies)
* [Usage](#Usage)
* [Pull images](#Pull-images)
* [Play](#Play)
* [Daemon](#Daemon)
* [Build](#Build)
* [Test](#Test)
* [Example](#Example)
* [Architecture](#Architecture)
* [List of Libraries](#List-of-Libraries)

This project provides several Dockerfiles for runtime environments for a list
of YAML processors.

The goal of this project is to be able to play with most available YAML
libraries out there and compare them.

Libraries can be tested for bugs, and it makes it easier to try out bugfixes
for a language for which you don't have any development libraries installed.

It was part of the [YAML Editor](https://github.com/yaml/yaml-editor) and then
outsourced in its own project.

The YAML editor allows to receive the output of a list of YAML processors in
vim, with a very helpful automatic tiled layout and nice shortcuts.

It currently can work with only one docker container at a time, that's one
reason why we build the `alpine-runtime-all` image.

Each library has one or more programs to process YAML input and output parsing
events or JSON. In the docker images they can be found under the `/yaml/bin`
directory.

## Quickstart

    source /path/to/yaml-runtimes/.rc

To play with PyYAML:

    yamlrun-docker-pull python
    docker run -i --rm yamlio/alpine-runtime-python py-pyyaml-event <t/data/input.yaml
    docker run -i --rm yamlio/alpine-runtime-python py-pyyaml-json <t/data/input.yaml
    docker run -i --rm yamlio/alpine-runtime-python py-pyyaml-yaml <t/data/input.yaml
    docker run -i --rm yamlio/alpine-runtime-python py-pyyaml-py <t/data/input.yaml

To play with libyaml:

    yamlrun-docker-pull static
    docker run -i --rm yamlio/alpine-runtime-static c-libyaml-event <t/data/input.yaml
    docker run -i --rm yamlio/alpine-runtime-static c-libyaml-yaml <t/data/input.yaml

## Dependencies

For some operations, you need to install the following dependencies:
* perl
* YAML::PP perl module
* jq

To install YAML::PP, first install the `cpanm` client (debian example):

    apt-get install cpanminus

Then install the module with `cpanm`:

    # Install YAML::PP into the local/ directory
    cpanm -l local --notest YAML::PP

The scripts will automatically use the `local/` directory to search for
modules. You could also do this manually by setting `PERL5LIB`:

    export PERL5LIB=$PWD/local/lib/perl5

## Usage

To list all libraries:

    make list

### Pull images

    # pull alpine-runtime-static
    make docker-pull-perl
    # pull alpine-runtime-node
    make docker-pull-node
    # pull alpine-runtime-all
    make docker-pull-all

### Play

To play around with the several processors, call them like this:

    docker run -i --rm yamlio/alpine-runtime-static c-libfyaml-event <t/data/input.yaml

To get a list of all available views:

    make list-views-static
    make list-views-all

### Daemon

By default, for every test a `docker run` will be executed. To make testing
a bit faster, you can run the containers in background:

    # Start all containers
    yamlrun-docker-start
    # Only start alpine-runtime-perl container
    yamlrun-docker-start perl

    # Test
    make testv

    # Stop all containers
    yamlrun-docker-stop
    # Only stop alpine-runtime-perl container
    yamlrun-docker-stop perl

    # List containers
    yamlrun-docker-status
    # Restart all
    yamlrun-docker-restart

Then you can run this instead:

    docker exec -i alpine-runtime-static c-libfyaml-event <t/data/input.yaml

Also the tests (see below) will run `docker exec` instead automatically.

### Build

To build all images, do

    make build

Note that this can take a while.

You can also just build a single environment or library:

    # build all javascript libraries
    make node
    # build C libyaml
    make c-libyaml
    # build perl YAML::PP
    make perl-pp

To list all images, do

    make list-images

### Test

To see if the build was successful and all programs work, run

    make test
    # or verbose:
    make testv

This will test each program with a simple YAML file.

To test only one runtime or library:

    make test LIBRARY=c-libyaml
    make testv RUNTIME=perl
    make testv RUNTIME=all LIBRARY=hs-hsyaml
    # Test all libraries in alpine-runtime-all image
    make testv RUNTIME=all

### Example

If you want to test a certain library, for example `c-libfyaml`, the steps would
be:

    make c-libfyaml
    make list-images
    make testv LIBRARY=c-libfyaml
    docker run -i --rm yamlio/alpine-runtime-static c-libfyaml-event <t/data/input.yaml
    docker run -i --rm yamlio/alpine-runtime-static c-libfyaml-json <t/data/input.yaml


## Architecture

So far all docker images are based on Alpine Linux.

For each environment there is a builder image and a runtime image.
The libraries are built in the builder containers, and all necessary
files are then copied into the runtime images.

## List of Libraries

Currently only official releases of the libraries are build. Allowing to
build from sources like git might be added at some point.

The list of libraries and their configuration can be found in
[list.yaml](list.yaml).

Type `make list` to see the following list:

| ID                | Language   | Name               | Version       | Runtime |
| ----------------- | ---------- | ------------------ |---------------| ------- |
| c-libfyaml        | C          | [libfyaml](https://github.com/pantoniou/libfyaml) | 0.7.12        | static  |
| c-libyaml         | C          | [libyaml](https://github.com/yaml/libyaml) | 0.2.5         | static  |
| cpp-rapidyaml     | C++        | [rapidyaml](https://github.com/biojppm/rapidyaml) | 0.4.0         | static  |
| cpp-yamlcpp       | C++        | [yaml-cpp](https://github.com/jbeder/yaml-cpp) | 0.8.0         | static  |
| dotnet-yamldotnet | C#         | [YamlDotNet](https://github.com/aaubry/YamlDotNet) | 11.2.1        | dotnet  |
| go-yaml           | Go         | [go-yaml](https://github.com/go-yaml/yaml) | v2            | static  |
| hs-hsyaml         | Haskell    | [HsYAML](https://github.com/haskell-hvr/HsYAML) | 0.2.1.0       | haskell |
| hs-reference      | Haskell    | [YAMLReference](https://github.com/orenbenkiki/yamlreference) | master        | haskell |
| java-snakeengine  | Java       | [SnakeYAML Engine](https://bitbucket.org/snakeyaml/snakeyaml-engine) | 2.11-SNAPSHOT | java    |
| java-snakeyaml    | Java       | [SnakeYAML](https://bitbucket.org/snakeyaml/snakeyaml/) | 2.5-SNAPSHOT  | java    |
| js-jsyaml         | Javascript | [js-yaml](https://github.com/nodeca/js-yaml) | 4.1.0         | node    |
| js-yaml           | Javascript | [yaml](https://github.com/eemeli/yaml) | 2.4.5         | node    |
| lua-lyaml         | Lua        | [lyaml](https://github.com/gvvaughan/lyaml) | 6.2.8         | lua     |
| nim-nimyaml       | Nim        | [NimYAML](https://github.com/flyx/NimYAML) | 0.16.0        | static  |
| perl-pp           | Perl       | [YAML::PP](https://metacpan.org/release/YAML-PP) | 0.38.0        | perl    |
| perl-pplibyaml    | Perl       | [YAML::PP::LibYAML](https://metacpan.org/release/YAML-PP-LibYAML) | 0.005         | perl    |
| perl-refparser    | Perl       | [Generated RefParser](https://metacpan.org/release/YAML-Parser) | 0.0.5         | perl    |
| perl-syck         | Perl       | [YAML::Syck](https://metacpan.org/release/YAML-Syck) | 1.34          | perl    |
| perl-tiny         | Perl       | [YAML::Tiny](https://metacpan.org/release/YAML-Tiny) | 1.74          | perl    |
| perl-xs           | Perl       | [YAML::XS (libyaml)](https://metacpan.org/release/YAML-LibYAML) | 0.89          | perl    |
| perl-yaml         | Perl       | [YAML.pm](https://metacpan.org/release/YAML) | 1.31          | perl    |
| py-pyyaml         | Python     | [PyYAML](https://github.com/yaml/pyyaml) | 5.3.1         | python  |
| py-ruamel         | Python     | [ruamel.yaml](https://bitbucket.org/ruamel/yaml) | 0.18.6        | python  |
| ruby-psych        | Ruby       | [psych](https://github.com/ruby/psych) | 4.0.3         | ruby    |
| rust-yamlrust     | Rust       | [yaml](https://github.com/chyh1990/yaml-rust) | 0.4.4         | static  |

## Contributing

See the [Contributing](Contributing.md) Guidelines
