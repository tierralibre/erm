defmodule Erm.Core.RelationTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Relation

  test "relations are listed by type" do
    {_st, _pr, _cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, :belongs_category, %{})
    assert length(entities) == 1
    assert List.first(entities).type == :belongs_category
  end

  test "relations are listed by type and to" do
    {_st, _pr, cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, :belongs_category, %{to: cat.uuid})
    assert length(entities) == 1
    assert List.first(entities).type == :belongs_category
  end

  test "relations are listed by type and from" do
    {_st, pr, _cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, :belongs_category, %{from: pr.uuid})
    assert length(entities) == 1
    assert List.first(entities).type == :belongs_category
  end

  test "relations are listed by type and from and to" do
    {_st, pr, cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, :belongs_category, %{from: pr.uuid, to: cat.uuid})
    assert length(entities) == 1
    assert List.first(entities).type == :belongs_category
  end
end