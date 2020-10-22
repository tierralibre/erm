defmodule Erm.Core.Relation do
  alias Erm.Core.Application

  defstruct [:type, :owner, :from, :to, :data, :valid_from, :valid_to]

  def new(%{type: type, from: from, to: to, data: data}) do
    %__MODULE__{
      type: type,
      from: from,
      to: to,
      owner: nil,
      data: data,
      valid_from: :os.system_time(:millisecond),
      valid_to: nil
    }
  end

  def add_relation(%Application{relations: relations} = application, from, to, type, data) do
    new_rel = new(%{type: type, from: from, to: to, data: data})
    {:ok, %Application{application | relations: relations ++ [new_rel]}, %{relation: new_rel}}
  end

  def remove_relation(%Application{relations: relations} = application, from, to, type) do
    {:ok,
     %Application{
       application
       | relations:
           Enum.filter(relations, fn rel ->
             rel.type != type or rel.from != from or rel.to != to
           end)
     }, %{}}
  end

  def update_relation(%Application{relations: relations} = application, from, to, type, data) do
    rel_to_update =
      Enum.find(relations, fn rel -> rel.type == type and rel.from == from and rel.to == to end)

    {:ok,
     %Application{
       application
       | relations: [
           %__MODULE__{rel_to_update | data: data}
           | Enum.filter(relations, fn rel ->
               rel.type != type or rel.from != from or rel.to != to
             end)
         ]
     }, %{}}
  end

  def list_relations(%Application{relations: relations}, type, %{from: from, to: to}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.from == from and rel.to == to end)
  end

  def list_relations(%Application{relations: relations}, type, %{from: from}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.from == from end)
  end

  def list_relations(%Application{relations: relations}, type, %{to: to}) do
    Enum.filter(relations, fn rel -> rel.type == type and rel.to == to end)
  end

  def list_relations(%Application{relations: relations}, type, %{}) do
    Enum.filter(relations, fn rel -> rel.type == type end)
  end
end
