defmodule Erm.Persistence do
  alias Erm.Core.{Entity, Relation, Application}
  @type app_name :: binary
  @type uuid :: binary
  @type from :: binary
  @type to :: binary

  @callback save_entity(app_name, %Entity{}) :: :ok | :error
  @callback remove_entity(app_name, uuid) :: :ok | :error
  @callback save_relation(app_name, %Relation{}) :: :ok | :error
  @callback remove_relation(app_name, from, to) :: :ok | :error
  @callback load_application(%Application{}) :: {:ok, %Application{}} | {:error, binary}
end
