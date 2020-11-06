defmodule CoreBuilders do
  defmacro __using__(_options) do
    quote do
      alias Erm.Core.{Application, Action}
      import CoreBuilders
    end
  end

  alias Erm.Core.{Application, Action}

  defmodule DumbActionImpl do
    def run(%Application{} = application, data) do
      {:ok, application, data}
    end
  end

  def dumb_actions do
    [dumb_action()]
  end

  def dumb_action do
    Action.new(:dumb_action, :internal, DumbActionImpl)
  end

  def applications do
    [
      Application.new("Pelikan inks", dumb_actions(), Erm.Persistence.Dumb),
      Application.new("Karkos inks", dumb_actions(), Erm.Persistence.Dumb)
    ]
  end

  def params() do
    %{test: "test"}
  end

  def application, do: List.first(applications())
end
