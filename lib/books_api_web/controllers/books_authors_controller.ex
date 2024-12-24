defmodule BooksApiWeb.BooksAuthorsController do
alias BooksApi.BooksAuthors
use BooksApiWeb, :controller
  def index(conn, _params) do
    books_authors = BooksAuthors.list_books_authors()
    conn
    |> put_view(BooksApiWeb.BooksAuthorsJSON)
    |> render("index.json", books_authors: books_authors)
  end
  def show(conn, %{"id" => id}) do
    case BooksAuthors.get_book_author(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "BookAuthor")
      book_author ->
        conn
        |> put_view(BooksApiWeb.BooksAuthorsJSON)
        |> render("show.json", book_author: book_author)
    end
  end
  def create(conn,  %{"book_id" => book_id, "author_id" => author_id}) do
    case BooksAuthors.create_book_author(%{"book_id" => book_id, "author_id" => author_id}) do
      {:ok, book_author} ->
        conn
        |> put_view(BooksApiWeb.BooksAuthorsJSON)
        |> render("show.json", book_author: book_author)
      {:error, :book_author_exists} ->
        conn
        |> put_status(:conflict)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "BookAuthor with this book_id and author_id already exists")
      _error ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("422.json", resource: "Invalid data")
    end
  end
  def update(conn, %{"id" => id, "book_id" => book_id, "author_id" => author_id}) do
    case BooksAuthors.update_book_author(id, %{"book_id" => book_id, "author_id" => author_id}) do
      {:ok, book_author} ->
        conn
        |> put_view(BooksApiWeb.BooksAuthorsJSON)
        |> render("show.json", book_author: book_author)
      {:error, :book_author_not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "BookAuthor")
      {:error, :book_author_exists} ->
        conn
        |> put_status(:conflict)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "BookAuthor with this book_id and author_id already exists")
      _error ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("422.json", resource: "Invalid data")
    end
  end
  def delete(conn, %{"id" => id}) do
    case BooksAuthors.get_book_author(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "BookAuthor")
      book_author ->
        case BooksAuthors.delete_book_author(book_author) do
          {:ok, _book_author} ->
            conn
            |> put_status(:no_content)
            |> send_resp(:no_content, "")
            {:error, _reason} ->
              conn
              |> put_status(:internal_server_error)
              |> json(%{error: "Unable to delete author"})
        end
    end
  end
end
