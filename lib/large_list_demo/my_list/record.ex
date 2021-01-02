defmodule LargeListDemo.MyList.Record do
  use Ecto.Schema
  import Ecto.Changeset

  schema "records" do
    field :name, :string
    field :value, :integer

    timestamps()
  end

  @doc false
  def changeset(record, attrs) do
    record
    |> cast(attrs, [:name, :value])
    |> validate_required([:name, :value])
  end
end
