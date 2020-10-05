defmodule Erm.Core.Actions.Locally.AddProductToCategory do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Relation


  @behaviour ActionImpl

  def run(%Application{} = application, %{from: from, to: to} = data) do
    Relation.add_relation(application, from, to, :belongs_category, data)
  end
end
