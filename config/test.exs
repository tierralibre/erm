use Mix.Config

config :erm, Erm.Repo,
  database: "erm_repo_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
