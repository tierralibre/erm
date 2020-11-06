defmodule Erm.Persistence.Dumb do
  alias Erm.Persistence
  alias Erm.Core.{Entity, Relation, Application}

  @behaviour Persistence

  def save_entity(_app_name, %Entity{} = _entity) do
    :ok
  end

  def save_relation(_app_name, %Relation{} = _relation) do
    :ok
  end

  def remove_entity(_app_name, _uuid) do
    :ok
  end

  def remove_relation(_app_name, _from, _to) do
    :ok
  end

  def load_application(%Application{} = application) do
    {:ok, application}
  end

end
