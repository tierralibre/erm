defmodule Erm.Core.Entity do
  alias Erm.Core.Application

  defstruct [:type, :id, :data]

  def new(%{type: type, data: data}) do
    %__MODULE__{
      type: type,
      id: nil,
      data: data
    }
  end

  def add_entity(%Application{} = application, type, data) do
    new_ent = new(%{type: type, data: data})
    {:ok, saved_rel} = application.persistence.save_entity(application.name, new_ent)
    {:ok, application, %{entity: saved_rel}}
  end

  def remove_entity(%Application{} = application, uuid) do
    {:ok, rem_entity} = application.persistence.remove_entity(application.name, uuid)
    {:ok, application, %{entity: rem_entity}}
  end

  def update_entity(%Application{} = application, uuid, data) do
    {:ok, updated_ent} =
      application.persistence.save_entity(application.name, %{id: uuid, data: data})

    {:ok, application, %{entity: updated_ent}}
  end

  def list_entities(%Application{name: app_name} = application, type, equality_field_values \\ []) do
    application.persistence.list_entities(app_name, type, equality_field_values)
  end

  def list_entities_by_relation(
        %Application{name: app_name} = application,
        relation_type,
        :from,
        to
      ) do
    application.persistence.list_entities_by_relation(app_name, relation_type, :from, to)
  end

  def list_entities_by_relation(
        %Application{name: app_name} = application,
        relation_type,
        :to,
        from
      ) do
    application.persistence.list_entities_by_relation(app_name, relation_type, :to, from)
  end

  def get_entity(%Application{name: app_name} = application, uuid) do
    application.persistence.get_entity(app_name, uuid)
  end
end
