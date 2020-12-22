defmodule Erm do
  @moduledoc """
  Documentation for `Erm`.
  """

  alias Erm.Boundary.ErmApi

  defdelegate run_action(app_name, action_name, params), to: ErmApi
  defdelegate run_action!(app_name, action_name, params), to: ErmApi
  defdelegate list_entities(app_name, type, equality_field_values), to: ErmApi
  defdelegate list_entities_by_relation(app_name, type, direction, id), to: ErmApi
  defdelegate get_entity(app_name, uuid), to: ErmApi
  defdelegate list_relations(app_name, type, properties), to: ErmApi
  defdelegate get_relation(app_name, type, from, to), to: ErmApi
end
