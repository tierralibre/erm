defmodule Erm.Core.Actions.Locally.RemoveProductFromCategory do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Relation

  @behaviour ActionImpl

  def run(%Application{} = application, %{from: from, to: to}) do
    Relation.remove_relation(application, from, to, :belongs_category)
  end
end
