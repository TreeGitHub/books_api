defmodule BooksApi.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
