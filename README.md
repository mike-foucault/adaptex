[![CircleCI](https://circleci.com/gh/mike-foucault/adaptex.svg?style=svg)](https://circleci.com/gh/mike-foucault/adaptex)

# Adaptex

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `adaptex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:adaptex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/adaptex](https://hexdocs.pm/adaptex).

## Dev Notes

docker build -t elixir-dev-inotify-tools:1.10.2 \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) .

docker run -it --rm \
  --mount "type=bind,src=$(pwd),dst=/opt/shared/workspace" \
  --workdir /opt/shared/workspace \
  elixir-dev-inotify-tools:1.10.2 /bin/bash

MIX_ENV=test mix test.watch
