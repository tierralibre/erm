use Mix.Config

config :erm, ecto_repos: [Erm.Repo]

import_config "#{Mix.env()}.exs"
