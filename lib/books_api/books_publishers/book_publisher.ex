defmodule BooksApi.BooksPublishers.BookPublisher do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books_publishers" do
    # Establish the relationships with Book and Publisher
    belongs_to :book, BooksApi.Books.Book
    belongs_to :publisher, BooksApi.Publishers.Publisher

    timestamps()
  end

  @doc false
  def changeset(book_publisher, attrs) do
    book_publisher
    |> cast(attrs, [:book_id, :publisher_id])
    |> validate_required([:book_id, :publisher_id])
  end
end
