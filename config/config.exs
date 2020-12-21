use Mix.Config

config :erm,
  ecto_repos: [Erm.Repo]

config :geo_postgis,
  json_library: Jason

import_config "#{Mix.env()}.exs"
