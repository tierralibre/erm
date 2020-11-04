defmodule Erm.Core.Actions.Locally.AddStock do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Relation

  @behaviour ActionImpl

  def run(%Application{} = application, %{"from" => from, "to" => to} = data) do
    Relation.add_relation(application, from, to, :stock, data)
  end
end
