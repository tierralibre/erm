defmodule Erm.Core.Relation do
  alias Erm.Core.Application

  defstruct [:type, :from, :to, :data]

  def new(%{type: type, from: from, to: to, data: data}) do
    %__MODULE__{
      type: type,
      from: from,
      to: to,
      data: data
    }
  end

  def add_relation(%Application{} = application, from, to, type, data) do
    new_rel = new(%{type: type, from: from, to: to, data: data})
    {:ok, saved_rel} = application.persistence.save_relation(application.name, new_rel)
    {:ok, application, %{relation: saved_rel}}
  end

  def remove_relation(%Application{name: app_name} = application, from, to, type) do
    {:ok, removed_rel} = application.persistence.remove_relation(app_name, from, to, type)
    {:ok, application, %{relation: removed_rel}}
  end

  def update_relation(%Application{} = application, from, to, type, data) do
    new_rel = new(%{type: type, from: from, to: to, data: data})
    {:ok, saved_rel} = application.persistence.save_relation(application.name, new_rel)
    {:ok, application, %{relation: saved_rel}}
  end

  def list_relations(app_name, persistence, type, query) do
    persistence.list_relations(app_name, type, query)
  end

  def get_relation(app_name, persistence, type, from, to) do
    persistence.get_relation(app_name, type, from, to)
  end
end
