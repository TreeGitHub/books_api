defmodule BooksApi.Authors.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :name, :string

    # Relationship with Books through the join table
    has_many :books_authors, BooksApi.BooksAuthors.BookAuthor
    has_many :books, through: [:books_authors, :book]

    timestamps()
  end

  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name, message: "Author name must be unique")
  end
end
