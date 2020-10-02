defmodule Erm.Core.Actions.Locally.AddStore do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity


  @behaviour ActionImpl

  def run(%Application{entities: entities} = application, data) do
    new_ent = Entity.new(%{type: :store, data: data})
    {:ok, %Application{application | entities: entities ++ [new_ent]}, %{store: new_ent}}
  end
end
