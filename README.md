# PlugSessionPg

Use PostgreSQL (ecto...) as session store.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `plug_session_pg` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:plug_session_pg, "~> 0.1.0"}
  ]
end
```

Add to your configuration:

```elixir
config :plug_session_pg,
  repo: [YOUR_MODULE].Repo,
  max_age: 3600
```

Update the plug session configuration:

```elixir
plug Plug.Session,
  store: PlugSessionPg.Store,
  ...
```

You can then create the sessions table in your database using the task :

    $ mix PlugSessionPg.install [YOUR_MODULE]

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/plug_session_pg](https://hexdocs.pm/plug_session_pg).

