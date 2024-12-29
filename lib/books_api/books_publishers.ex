defmodule BooksApi.BooksPublishers do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.BooksPublishers.BookPublisher
  def list_books_publishers do
    Repo.all(BookPublisher)
  end
  def get_book_publisher(id) do
    Repo.get(BookPublisher, id)
  end
  def create_book_publisher(attrs \\ %{}) do
    book_id = attrs["book_id"]
    publisher_id = attrs["publisher_id"]

    case Repo.get_by(BookPublisher, book_id: book_id, publisher_id: publisher_id) do
      nil ->
        %BookPublisher{}
        |> BookPublisher.changeset(attrs)
        |> Repo.insert()

      _existing_book_publisher ->
        {:error, :book_publisher_exists}
    end
  end
  def update_book_publisher(id, attrs \\ %{}) do
    case Repo.get(BookPublisher, id) do
      nil ->
        {:error, :book_publisher_not_found}

      book_publisher ->
        book_id = attrs["book_id"]
        publisher_id = attrs["publisher_id"]

        case Repo.get_by(BookPublisher, book_id: book_id, publisher_id: publisher_id) do
          nil ->
            book_publisher
            |> BookPublisher.changeset(attrs)
            |> Repo.update()

          _existing_book_publisher ->
            {:error, :book_publisher_exists}
        end
    end
  end
  def delete_book_publisher(%BookPublisher{} = book_publisher) do
    Repo.delete(book_publisher)
  end
  def create_relationship(book_id, publisher_id) do
      IO.inspect(book_id, label: "Book ID")
      IO.inspect(publisher_id, label: "Publisher ID")
      IO.inspect(BookPublisher, label: "BookPublisher Module")

    case Repo.get_by(BookPublisher, book_id: book_id, publisher_id: publisher_id) do
      nil ->
        %BookPublisher{}
        |> BookPublisher.changeset(%{book_id: book_id, publisher_id: publisher_id})
        |> Repo.insert()

      _ ->
        {:error, :duplicate_relationship}
    end
  end
end
