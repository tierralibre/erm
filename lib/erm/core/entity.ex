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
     }, %{}}
  end

  def update_entity(%Application{entities: entities} = application, uuid, data) do
    ent_to_update = Enum.find(entities, fn entity -> entity.uuid == uuid end)

    {:ok,
     %Application{
       application
       | entities: [
           %__MODULE__{ent_to_update | data: data}
           | Enum.filter(entities, fn entity -> entity.uuid != uuid end)
         ]
     }, %{}}
  end

  def list_entities(%Application{entities: entities}, type) do
    Enum.filter(entities, fn entity -> entity.type == type end)
  end

  def get_entity(%Application{entities: entities}, uuid) do
    Enum.find(entities, fn entity -> entity.uuid == uuid end)
  end
end
