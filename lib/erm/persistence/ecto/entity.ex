defmodule Erm.Persistence.Entity do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_fields [:type, :app, :data]

  schema "entities" do
    field(:app, :string)
    field(:type, :string)
    field(:data, :map)
  end

  @doc """
  Creates a changeset based on the `model` and `params`.
  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params) do
    model
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
  end

  def new(%Erm.Core.Entity{} = params) do
    %__MODULE__{}
    |> changeset(params |> Map.from_struct())
  end

  def new(%{} = params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def to_core_entity(model) do
    Erm.Core.Entity.new(Map.from_struct(model))
    |> Map.put(:id, model.id)
  end
end
