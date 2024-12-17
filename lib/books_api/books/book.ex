defmodule BooksApi.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :tagline, :string
    field :summary, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :tagline, :summary])
    |> validate_required([:title])
  end
end
