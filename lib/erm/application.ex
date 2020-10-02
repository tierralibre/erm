defmodule Erm.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Erm.Boundary.ApplicationManager

  def start(_type, _args) do
    children = [
      {ApplicationManager, ApplicationManager.registered_applications}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Erm.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
