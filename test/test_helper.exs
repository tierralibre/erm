Code.require_file("support/core_builders.exs", __DIR__)
Code.require_file("support/locally_builders.exs", __DIR__)
Ecto.Adapters.SQL.Sandbox.mode(Erm.Repo, :manual)

ExUnit.start()
