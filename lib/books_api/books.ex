defmodule BooksApi.Books do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.Books.Book
  def list_books do
    Repo.all(Book)
  end
  def get_book(id) do
    Repo.get(Book, id)
  end
  def create_book(attrs \\ %{}) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert()
  end
  def update_book(id, attrs) do
    book = Repo.get(Book, id)
    case book do
      _book ->
        book
        |> Book.changeset(attrs)
        |> Repo.update()

    end
  end
  def delete_book(%Book{} = book) do
    Repo.delete(book)
  end
  def change_book(%Book{} = book, attrs \\ %{}) do
    Book.changeset(book, attrs)
  end
  # Fetch a book by its ID and preload authors through the books_authors join table
  def get_book_with_authors(id) do
    Book
    |> Repo.get(id)
    |> Repo.preload(:authors)  # Preload authors through the join table
  end
end
