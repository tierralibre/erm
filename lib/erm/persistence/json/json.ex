defmodule Erm.Persistence.Json do
  alias Erm.Persistence
  alias Erm.Core.{Entity, Relation, Application}

  @behaviour Persistence

  def save_entity(app_name, %Entity{} = entity) do
    read_json("#{app_name}.json")
    |> insert_entity(entity |> entity_to_map())
    |> write_json("#{app_name}.json")
  end

  def save_relation(app_name, %Relation{} = relation) do
    read_json("#{app_name}.json")
    |> insert_relation(relation |> relation_to_map())
    |> write_json("#{app_name}.json")
  end

  def remove_entity(app_name, uuid) do
    read_json("#{app_name}.json")
    |> remove_entity_from_map(uuid)
    |> write_json("#{app_name}.json")
  end

  def remove_relation(app_name, from, to) do
    read_json("#{app_name}.json")
    |> remove_relation_from_map(from, to)
    |> write_json("#{app_name}.json")
  end

  def load_application(%Application{name: name} = application) do
    file_name = "#{name}.json"
    if not File.exists?(file_name) do
      create_empty_file(file_name)
    end
    app =
      read_json(file_name)
      |> insert_into_app(application)

    {:ok, app}
  end

  defp create_empty_file(file) do
    %{"relations" => [], "entities" => []}
    |> write_json(file)
  end

  defp insert_into_app(%{"relations" => relations, "entities" => entities}, application) do
    application
    |> insert_relations_into_app(relations)
    |> insert_entities_into_app(entities)
  end

  defp remove_entity_from_map(%{"entities" => entities} = app_map, uuid) do
    %{ app_map | "entities" => Enum.filter( entities, & &1["uuid"] != uuid) }
  end

  defp remove_relation_from_map(%{"relations" => relations} = app_map, from, to) do
    %{ app_map | "relations" => Enum.filter( relations, & not (&1["from"] == from and &1["to"] == to) )  }
  end


  defp insert_relations_into_app(application, relations_map) do
    %Application{ application | relations: Enum.map(relations_map, & map_to_relation(&1))}
  end

  defp insert_entities_into_app(application, entities_map) do
    %Application{ application | entities: Enum.map(entities_map, & map_to_entity(&1))}
  end

  defp insert_relation(json_map, %{"from" => from, "to" => to} = relation) do
    %{json_map | "relations" => [relation | Enum.filter(json_map["relations"], & not (&1["from"] == from and &1["to"] == to))] }
  end

  defp insert_entity(json_map, %{"uuid" => uuid } = map_entity) do
    %{json_map | "entities" => [map_entity | Enum.filter(json_map["entities"], & &1["uuid"] != uuid )] }
  end

  defp map_to_entity(%{"type" => type_str, "uuid" => uuid, "data" => data}) do
    %Entity{type: String.to_atom(type_str), uuid: uuid, data: data}
  end

  defp map_to_relation(%{"type" => type_str, "from" => from, "to" => to, "data" => data}) do
    %Relation{type: String.to_atom(type_str), from: from, to: to, data: data}
  end

  defp entity_to_map(%Entity{type: type, uuid: uuid, data: data} ) do
    %{"type" => Atom.to_string(type), "uuid" => uuid, "data" => data}
  end

  defp relation_to_map(%Relation{type: type, from: from, to: to, data: data}) do
    %{"type" => Atom.to_string(type), "from" => from, "to" => to, "data" => data}
  end

  defp read_json(file) do
    with {:ok, body} <- File.read(file),
         {:ok, json} <- Jason.decode(body)
    do
      json
    end
  end

  defp write_json(data, file) do
    with {:ok, text} <- Jason.encode(data),
         :ok <- File.write(file, text)
    do
      :ok
    end
  end
end
