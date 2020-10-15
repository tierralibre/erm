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

  test "entities are found by id" do
    {st, _pr, _cat, app} = create_locally_entities()
    st = Entity.get_entity(app, st.uuid)
  end
end
