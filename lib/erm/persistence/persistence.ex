defmodule Erm.Persistence do
  alias Erm.Core.{Entity, Relation, Application}
  @type app_name :: binary
  @type uuid :: binary
  @type from :: binary
  @type to :: binary
  @type type :: binary
  @type relation_type :: :from | :to

  @callback save_entity(app_name, map) :: {:ok, %Entity{}} | :error
  @callback remove_entity(app_name, uuid) :: {:ok, %Entity{}} | :error
  @callback save_relation(app_name, %Relation{}) :: {:ok, %Relation{}} | :error
  @callback remove_relation(app_name, from, to, type) :: {:ok, %Relation{}} | :error
  @callback load_application(%Application{}) :: {:ok, %Application{}} | :error

  @callback get_relation(app_name, type, from, to) :: %Relation{} | nil
  @callback list_relations(app_name, type, map) :: [%Relation{}]
  @callback list_entities(app_name, type, map) :: [%Entity{}]
  @callback list_entities_by_relation(app_name, type, relation_type, to) :: [%Entity{}]
  @callback get_entity(app_name, uuid) :: %Entity{} | nil
end
