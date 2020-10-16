defmodule Erm.Core.Entity do
  alias Erm.Core.Application

  defstruct [:type, :uuid, :owner, :permissions, :data, :valid_from, :valid_to]

  def new(%{type: type, data: data}) do
    %__MODULE__{
      type: type,
      uuid: UUID.uuid1(),
      owner: nil,
      permissions: nil,
      data: data,
      valid_from: :os.system_time(:millisecond),
      valid_to: nil
    }
  end

  def add_entity(%Application{entities: entities} = application, type, data) do
    new_ent = new(%{type: type, data: data})
    {:ok, %Application{application | entities: entities ++ [new_ent]}, %{entity: new_ent}}
  end

  def remove_entity(%Application{entities: entities} = application, uuid) do
    {:ok,
     %Application{
       application
       | entities: Enum.filter(entities, fn entity -> entity.uuid != uuid end)
     }, %{entity: Enum.find(entities, fn entity -> entity.uuid == uuid end)}}
  end

  def update_entity(%Application{entities: entities} = application, uuid, data) do
    ent_to_update = Enum.find(entities, fn entity -> entity.uuid == uuid end)
    updated = %__MODULE__{ent_to_update | data: data}

    {:ok,
     %Application{
       application
       | entities: [
           updated
           | Enum.filter(entities, fn entity -> entity.uuid != uuid end)
         ]
     }, %{entity: updated}}
  end

  def list_entities(%Application{entities: entities}, type, equality_field_values \\ []) do
    Enum.filter(entities, fn entity ->
      entity.type == type and has_all_field_values?(entity.data, equality_field_values)
    end)
  end

  def get_entity(%Application{entities: entities}, uuid) do
    Enum.find(entities, fn entity -> entity.uuid == uuid end)
  end

  defp has_all_field_values?(data, equality_map_field_values) do
    Enum.all?(equality_map_field_values, fn {key, value} -> data[key] == value end)
  end
end
