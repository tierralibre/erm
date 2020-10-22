defmodule Erm.Core.EntityTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Entity

  test "new entities are created" do
    data = %{name: "Nostromo"}
    new_ent = Entity.new(%{type: :store, data: data})
    assert %Entity{data: data, type: :store} = new_ent
    assert is_binary(new_ent.uuid)
    assert is_number(new_ent.valid_from)
  end

  test "entities are listed by type" do
    {_st, _pr, _cat, app} = create_locally_entities()
    entities = Entity.list_entities(app, :store)
    assert length(entities) == 1
    assert List.first(entities).type == :store
  end

  test "entities are listed by type and attributes" do
    {_st, _pr, _cat, app} = create_locally_entities()
    entities = Entity.list_entities(app, :product, color: "red")
    assert length(entities) == 1
    assert List.first(entities).type == :product
    entities = Entity.list_entities(app, :product, color: "green")
    assert length(entities) == 0
  end

  test "entities are found by id" do
    {st, _pr, _cat, app} = create_locally_entities()
    assert st == Entity.get_entity(app, st.uuid)
  end

  test "entities are found by relation" do
    {_st, pr, cat, app} = create_locally_entities_and_relations()
    entities = Entity.list_entities_by_relation(app, :belongs_category, :to, pr.uuid)
    assert length(entities) == 1
    assert List.first(entities) == cat
  end
end
