defmodule Erm.Core.Actions.Locally.AddStore do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity
  alias Erm.Core.Relation
  alias Erm.Repo

  @behaviour ActionImpl

  def run(%Application{} = application, %{"h3index" => h3index} = data) do
    Entity.add_entity(application, "store", data, h3index)
  end

  def run(%Application{} = application, %{"seller" => owner_id, "store" => store_data }) do
    
    {:ok, %{store: store}} = 
      Ecto.Multi.new()
      |> Ecto.Multi.run(:store, fn repo, %{} ->
        new_ent = Entity.new(%{type: "store", data: store_data, h3index: nil})
        application.persistence.save_entity(application.name, new_ent, repo)
      end)
      |> Ecto.Multi.run(:seller_owns_store, fn repo, %{store: store} ->
        new_rel = Relation.new(%{type: "seller_owns_store", from: owner_id, to: store.id, data: %{}})
        application.persistence.save_relation(application.name, new_rel, repo)
      end)
      |> Repo.transaction()
    
    {:ok, application, %{entity: store}}
  end
end
