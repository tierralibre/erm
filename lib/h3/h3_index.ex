if Code.ensure_loaded?(Ecto.Type) do
  defmodule H3.PostGIS.H3Index do
    @moduledoc """
    Implements the Ecto.Type behaviour for h3index
    """

    if macro_exported?(Ecto.Type, :__using__, 1) do
      use Ecto.Type
    else
      @behaviour Ecto.Type
    end

    def type, do: :h3index

    def blank?(_), do: false

    def load(h3_index) when is_binary(h3_index) do
      {:ok, h3_index}
    end

    def load(_), do: :error

    def dump(h3_index) when is_binary(h3_index) do
      {:ok, h3_index}
    end

    def dump(_), do: :error

    def cast({:ok, value}), do: cast(value)

    def cast(h3_index) when is_list(h3_index) do
      {:ok, "#{h3_index}"}
    end

    def cast(h3_index) when is_binary(h3_index) do
      {:ok, h3_index}
    end

    def cast(_), do: :error

    def embed_as(_), do: :self

    def equal?(a, b), do: a == b
  end
end
