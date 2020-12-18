defmodule Erm.Core.Actions.Locally.AddProduct do
  alias Erm.Core.Actions.ActionImpl
  alias Erm.Core.Application
  alias Erm.Core.Entity
  alias Erm.Core.Relation
  alias Erm.Repo

  @behaviour ActionImpl

  def run(%Application{} = application, %{"store" => store_id, "product" => product_data }) do
    
    {:ok, %{product: product}} = 
      Ecto.Multi.new()
      |> Ecto.Multi.run(:product, fn repo, %{} ->
        new_ent = Entity.new(%{type: "product", data: product_data, h3index: nil})
        application.persistence.save_entity(application.name, new_ent, repo)
      end)
      |> Ecto.Multi.run(:store_sells_product, fn repo, %{product: product} ->
        new_rel = Relation.new(%{type: "store_sells_product", from: store_id, to: product.id, data: %{}})
        application.persistence.save_relation(application.name, new_rel, repo)
      end)
      |> Repo.transaction()
    
    {:ok, application, %{entity: product}}
  end
end
