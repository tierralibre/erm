defmodule Erm.Core.Action do
  alias Erm.Core.Relation
  alias Erm.Core.Entity

  defstruct [
    :name,
    :permissions,
    :type,
    :implementation,
    :input,
    :instructions,
    :output,
    :url_call
  ]

  def new(name, :instructions, input, instructions, output) do
    %__MODULE__{
      name: name,
      permissions: nil,
      type: :instructions,
      input: input,
      instructions: instructions,
      output: output
    }
  end

  def new(name, :internal, implementation) do
    %__MODULE__{
      name: name,
      permissions: nil,
      type: :internal,
      implementation: implementation
    }
  end

  def new(name, :external, url_call) do
    %__MODULE__{
      name: name,
      permissions: nil,
      type: :external,
      url_call: url_call
    }
  end

  def run_action(
        %__MODULE__{type: :internal, implementation: implementation},
        application,
        params
      ) do
    apply(implementation, :run, [application, params])
  end

  def run_action(
        %__MODULE__{
          type: :instructions,
          input: input,
          instructions: instructions,
          output: output
        },
        application,
        params
      ) do
    run_steps(application.name, input, params, instructions)
    |> return_output(output)
  end

  defp return_output({:ok, baggage}, output) do
    {
      :ok,
      for {key, name} <- output, into: %{} do
        {String.to_atom(key), baggage[name]}
      end
    }
  end

  defp return_output(error, _output), do: error

  defp run_steps(app_name, input, params, steps) do
    steps
    |> Enum.reduce(Ecto.Multi.new(), fn step, multi ->
      Ecto.Multi.run(multi, step["name"], fn repo, bagage ->
        case step["instruction"] do
          "add_entity" -> add_entity(app_name, step, params, bagage, repo)
          "update_entity" -> update_entity(app_name, step, input, params, bagage, repo)
          "add_relation" -> add_relation(app_name, step, input, params, bagage, repo)
          "update_relation" -> update_relation(app_name, step, input, params, bagage, repo)
          "delete_relation" -> delete_relation(app_name, step, input, params, bagage, repo)
          "delete_entity" -> delete_entity(app_name, step, input, params, bagage, repo)
        end
      end)
    end)
    |> Erm.Repo.transaction()
  end

  defp add_entity(app_name, step, params, bagage, repo) do
    data = find_data(step["data"], params, bagage)
    new_ent = Entity.new(%{type: step["type"], data: data})
    Erm.Persistence.Ecto.save_entity(app_name, new_ent, repo)
  end

  defp update_entity(app_name, step, input, params, bagage, repo) do
    data = find_data(step["data"], params, bagage)
    id = find_ft(step["id"], input, params, bagage)
    up_entity = %{type: step["type"], data: data, id: id} 
    Erm.Persistence.Ecto.save_entity(app_name, up_entity, repo)
  end

  defp add_relation(app_name, step, input, params, bagage, repo) do
    from = find_ft(step["from"], input, params, bagage)
    to = find_ft(step["to"], input, params, bagage)
    data = find_data(step["data"], params, bagage)
    new_rel = Relation.new(%{type: step["type"], from: from, to: to, data: data})
    Erm.Persistence.Ecto.save_relation(app_name, new_rel, repo)
  end

  defp update_relation(app_name, step, input, params, bagage, repo) do
    data = find_data(step["data"], params, bagage)
    from = find_ft(step["from"], input, params, bagage)
    to = find_ft(step["to"], input, params, bagage)
    update_rel = Relation.new(%{type: step["type"], from: from, to: to, data: data})
    Erm.Persistence.Ecto.save_relation(app_name, update_rel, repo)
  end

  defp delete_relation(app_name, step, input, params, bagage, repo) do
    from = find_ft(step["from"], input, params, bagage)
    to = find_ft(step["to"], input, params, bagage)
    type = step["type"]
    Erm.Persistence.Ecto.remove_relation(app_name, type, from, to, repo)
  end

  defp delete_entity(app_name, step, input, params, bagage, repo) do
    id = find_ft(step["id"], input, params, bagage)
    Erm.Persistence.Ecto.remove_entity(app_name, id, repo)
  end

  defp find_data(data_name, params, bg) do
    find_data_in_bg(data_name, bg)
    |> else_find_data_in_input(data_name, params)
  end

  defp find_data_in_bg(data_name, bg) do
    case Map.get(bg, data_name) do
      nil -> nil
      entity -> entity.data
    end
  end

  defp else_find_data_in_input(nil, data_name, params) do
    case Map.get(params, data_name) do
      nil -> %{}
      data -> data
    end
  end

  defp else_find_data_in_input(data, _data_name, _params), do: data

  defp find_ft(ft_name, input, params, bg) do
    find_ft_in_bg(ft_name, bg)
    |> else_find_ft_in_input(ft_name, input, params)
  end

  defp find_ft_in_bg(ft_name, bg) do
    case Map.get(bg, ft_name) do
      nil -> nil
      entity -> entity.id
    end
  end

  defp else_find_ft_in_input(nil, ft_name, input, params) do
    case Map.get(params, ft_name) do
      nil ->
        nil

      ft ->
        case Map.get(input, ft_name) do
          "id" -> ft
          "map" -> ft["id"]
          _ -> ft
        end
    end
  end

  defp else_find_ft_in_input(data, _input, _ft_name, _params), do: data
end
