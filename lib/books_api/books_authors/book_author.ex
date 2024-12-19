defmodule BooksApi.BooksAuthors.BookAuthor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books_authors" do
    field :book_id, :integer
    field :author_id, :integer

    timestamps()
  end

  @doc false
  def changeset(book_author, attrs) do
    book_author
    |> cast(attrs, [:book_id, :author_id])
    |> validate_required([:book_id, :author_id])
  end
end
