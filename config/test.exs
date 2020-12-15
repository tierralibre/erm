use Mix.Config

config :erm, Erm.Repo,
  database: "erm_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 15432,
  types: Erm.PostgresTypes,
  pool: Ecto.Adapters.SQL.Sandbox
