defmodule Erm.Core.RelationTest do
  use ExUnit.Case
  use LocallyBuilders

  alias Erm.Core.Relation

  setup do
    # Explicitly get a connection before each test
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Erm.Repo)
  end

  test "relations are listed by type" do
    {_st, _pr, _cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, "belongs_category", %{})
    assert length(entities) == 1
    assert List.first(entities).type == "belongs_category"
  end

  test "relations are listed by type and to" do
    {_st, _pr, cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, "belongs_category", %{to: cat.id})
    assert length(entities) == 1
    assert List.first(entities).type == "belongs_category"
  end

  test "relations are listed by type and from" do
    {_st, pr, _cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, "belongs_category", %{from: pr.id})
    assert length(entities) == 1
    assert List.first(entities).type == "belongs_category"
  end

  test "relations are listed by type and from and to" do
    {_st, pr, cat, app} = create_locally_entities_and_relations()
    entities = Relation.list_relations(app, "belongs_category", %{from: pr.id, to: cat.id})
    assert length(entities) == 1
    assert List.first(entities).type == "belongs_category"
  end

  test "gets relations" do
    {_st, pr, cat, app} = create_locally_entities_and_relations()

    assert %Relation{type: "belongs_category"} =
             Relation.get_relation(app, "belongs_category", pr.id, cat.id)
  end
end
