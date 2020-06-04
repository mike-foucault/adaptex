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

docker run -it --rm \
  --mount "type=bind,src=$(pwd),dst=/opt/shared/adaptex" \
  --workdir /opt/shared/adaptex \
  elixir-dev:1.10.2 /bin/bash
