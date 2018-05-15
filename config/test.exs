use Mix.Config

config :logger, level: :warn

config :plug_session_pg, TestRepo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "plug_session_pg_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "test/support"

  config :plug_session_pg,
    ecto_repos: [TestRepo]