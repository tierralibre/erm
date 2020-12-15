defmodule LocallyBuilders do
  defmacro __using__(_options) do
    quote do
      import LocallyBuilders
    end
  end

  alias Erm.Core.Application

  alias Erm.Core.Actions.Locally.{
    AddStore,
    AddProduct,
    AddProductCategory,
    AddStock,
    AddProductToCategory
  }

  def create_locally_entities do
    {:ok, application1, %{entity: store}} =
      AddStore.run(Application.new("Application", [], Erm.Persistence.Ecto), %{
        "name" => "Gross Grocery",
        "h3index" => "891fb466257ffff"
      })

    {:ok, application2, %{entity: product}} =
      AddProduct.run(application1, %{"name" => "Rotten tomato", "color" => "red"})

    {:ok, application3, %{entity: category}} =
      AddProductCategory.run(application2, %{"name" => "Grocery"})

    {store, product, category, application3}
  end

  def create_locally_entities_and_relations do
    {store, product, category, application1} = create_locally_entities()

    {:ok, application2, %{}} =
      AddStock.run(application1, %{
        "from" => product.id,
        "to" => store.id,
        "units" => 200,
        "price" => "20.34 EUR"
      })

    {:ok, application3, %{}} =
      AddProductToCategory.run(application2, %{from: product.id, to: category.id})

    {store, product, category, application3}
  end
end
