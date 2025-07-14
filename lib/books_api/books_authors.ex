defmodule BooksApi.BooksAuthors do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.BooksAuthors.BookAuthor

  def list_books_authors do
    Repo.all(BookAuthor)
  end

  def get_book_author(id) do
    Repo.get(BookAuthor, id)
  end

  def create_book_author(attrs \\ %{}) do
    book_id = attrs["book_id"]
    author_id = attrs["author_id"]

    case Repo.get_by(BookAuthor, book_id: book_id, author_id: author_id) do
      nil ->
        %BookAuthor{}
        |> BookAuthor.changeset(attrs)
        |> Repo.insert()

      _existing_book_author ->
        {:error, :book_author_exists}
    end
  end

  def update_book_author(id, attrs \\ %{}) do
    case Repo.get(BookAuthor, id) do
      nil ->
        {:error, :book_author_not_found}

      book_author ->
        book_id = attrs["book_id"]
        author_id = attrs["author_id"]

        case Repo.get_by(BookAuthor, book_id: book_id, author_id: author_id) do
          nil ->
            book_author
            |> BookAuthor.changeset(attrs)
            |> Repo.update()

          _existing_book_author ->
            {:error, :book_author_exists}
        end
    end
  end

  def delete_book_author(%BookAuthor{} = book_author) do
    Repo.delete(book_author)
  end

  def create_relationship(book_id, author_id) do
    case Repo.get_by(BookAuthor, book_id: book_id, author_id: author_id) do
      nil ->
        %BookAuthor{}
        |> BookAuthor.changeset(%{book_id: book_id, author_id: author_id})
        |> Repo.insert()

      _ ->
        {:error, :duplicate_relationship}
    end
  end
end
