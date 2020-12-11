defmodule Erm.Core.Actions.Locally.UpdateStock do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Relation

  @behaviour ActionImpl

  def run(%Application{} = application, %{from: from, to: to, data: data}) do
    Relation.update_relation(application, from, to, "stock", data)
  end
end
