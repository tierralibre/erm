use Mix.Config

config :erm, Erm.Repo,
  database: "erm_repo_dev",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: 15432,
  types: Erm.PostgresTypes
