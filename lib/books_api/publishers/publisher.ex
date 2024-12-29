defmodule BooksApi.Publishers.Publisher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "publishers" do
    field :name, :string
    field :address, :string
    field :phone_number, :string
    field :website, :string

    timestamps()
  end

  @doc false
  def changeset(publisher, attrs) do
    publisher
    |> cast(attrs, [:name, :address, :phone_number, :website])
    |> validate_required([:name])
    |> validate_format(:website, ~r/^https?:\/\/[\w\-\.]+/)
    |> unique_constraint(:name)
  end
end
