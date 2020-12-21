defmodule LocallyBuilders do
  defmacro __using__(_options) do
    quote do
      import LocallyBuilders
    end
  end

  alias Erm.Core.Application
  alias Erm.Core.Relation
  alias Erm.Core.Entity

  def create_locally_entities do
    application = Application.new("Application", [], Erm.Persistence.Ecto)

    {:ok, _app, %{entity: store}} =
      Entity.add_entity(
        application,
        "store",
        %{
          "name" => "Gross Grocery"
        },
        "891fb466257ffff"
      )

    {:ok, _app, %{entity: product}} =
      Entity.add_entity(application, "product", %{"name" => "Rotten tomato", "color" => "red"})

    {:ok, _app, %{entity: category}} =
      Entity.add_entity(application, "product_category", %{"name" => "Grocery"})

    {store, product, category, application}
  end

  def create_locally_entities_and_relations do
    {store, product, category, application} = create_locally_entities()

    {:ok, _app, %{}} =
      Relation.add_relation(application, product.id, store.id, "stock", %{
        "units" => 200,
        "price" => "20.34 EUR"
      })

    {:ok, _app, %{}} =
      Relation.add_relation(application, product.id, category.id, "belongs_category", %{})

    {store, product, category, application}
  end
end
