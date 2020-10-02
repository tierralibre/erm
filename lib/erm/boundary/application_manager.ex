defmodule Erm.Boundary.ApplicationManager do
  use GenServer

  alias Erm.Core.Application

  def init(applications), do: {:ok, applications}

  def start_link(applications), do: GenServer.start_link(__MODULE__, applications, name: __MODULE__)

  def registered_applications, do: [Application.new("Locally")]

  def get_applications do
    GenServer.call(__MODULE__, :get_applications)
  end

  def handle_call(:get_applications, _from, applications), do: {:reply, applications, applications}
end
