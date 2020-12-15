defmodule Erm.Core.EntityTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Entity

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Erm.Repo)
  end

  test "new entities are created" do
    data = %{"name" => "Nostromo"}
    new_ent = Entity.new(%{type: "store", data: data})
    assert %Entity{data: _data, type: "store"} = new_ent
  end

  test "entities are listed by type" do
    {_st, _pr, _cat, app} = create_locally_entities()
    entities = Entity.list_entities(app.name, app.persistence, "store")
    assert length(entities) == 1
    assert List.first(entities).type == "store"
  end

  test "entities are listed by type and attributes" do
    {_st, _pr, _cat, app} = create_locally_entities()
    entities = Entity.list_entities(app.name, app.persistence, "product", [{"color", "red"}])
    assert length(entities) == 1
    assert List.first(entities).type == "product"
    entities = Entity.list_entities(app.name, app.persistence, "product", [{"color", "green"}])
    assert length(entities) == 0
  end

  test "entities are found by id" do
    {st, _pr, _cat, app} = create_locally_entities()
    assert st == Entity.get_entity(app.name, app.persistence, st.id)
  end

  test "entities are found by relation" do
    {_st, pr, cat, app} = create_locally_entities_and_relations()
    entities = Entity.list_entities_by_relation(app.name, app.persistence, "belongs_category", :to, pr.id)
    assert length(entities) == 1
    assert List.first(entities) == cat
  end

  test "store has h3 index" do
    {store, _pr, _cat, _app} = create_locally_entities_and_relations()
    assert store.h3index == "891fb466257ffff"
  end
end
