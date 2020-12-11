defmodule Erm.Persistence.Relation do
  use Ecto.Schema
  @primary_key false

  import Ecto.Changeset

  @required_fields [:app, :type, :data, :from, :to]

  schema "relations" do
    field(:app, :string, primary_key: true)
    field(:type, :string, primary_key: true)
    field(:data, :map)
    field(:from, :string, primary_key: true)
    field(:to, :string, primary_key: true)
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

  def new(params) do
    %__MODULE__{}
    |> changeset(params)
  end

  def to_core_relation(model) do
    Erm.Core.Relation.new(model)
  end
end
