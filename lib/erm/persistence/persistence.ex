defmodule Erm.Persistence do
  alias Erm.Core.{Entity, Relation, Application}
  @type app_name :: binary


  @callback save_entity(app_name, %Entity{}) :: :ok | :error
  @callback save_relation(app_name, %Relation{}) :: :ok | :error
  @callback load_application(%Application{}) :: {:ok, %Application{}} | {:error, binary}
end
