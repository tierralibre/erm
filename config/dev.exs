use Mix.Config

config :erm, Erm.Repo,
  database: "erm_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 15432,
  types: Erm.PostgresTypes
