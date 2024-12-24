defmodule BooksApi.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    field :tagline, :string
    field :summary, :string

    # Establish the relationship with BooksAuthors and Authors
    has_many :books_authors, BooksApi.BooksAuthors.BookAuthor
    has_many :authors, through: [:books_authors, :author]

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :tagline, :summary])
    |> validate_required([:title])
  end
end
