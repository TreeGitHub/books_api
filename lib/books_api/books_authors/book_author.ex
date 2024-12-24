defmodule BooksApi.BooksAuthors.BookAuthor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books_authors" do
    # Establish the relationships with Book and Author
    belongs_to :book, BooksApi.Books.Book
    belongs_to :author, BooksApi.Authors.Author

    timestamps()
  end

  @doc false
  def changeset(book_author, attrs) do
    book_author
    |> cast(attrs, [:book_id, :author_id])
    |> validate_required([:book_id, :author_id])
  end
end
