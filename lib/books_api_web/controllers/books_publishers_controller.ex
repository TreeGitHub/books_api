defmodule BooksApiWeb.BooksPublishersController do
  alias BooksApi.BooksPublishers
  use BooksApiWeb, :controller
    def index(conn, _params) do
      books_publishers = BooksPublishers.list_books_publishers()
      conn
      |> put_view(BooksApiWeb.BooksPublishersJSON)
      |> render("index.json", books_publishers: books_publishers)
    end
    def show(conn, %{"id" => id}) do
      case BooksPublishers.get_book_publisher(id) do
        nil ->
          conn
          |> put_status(:not_found)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("404.json", resource: "BookPublisher")
        book_publisher ->
          conn
          |> put_view(BooksApiWeb.BooksPublishersJSON)
          |> render("show.json", book_publisher: book_publisher)
      end
    end
    def create(conn,  %{"book_id" => book_id, "publisher_id" => publisher_id}) do
      case BooksPublishers.create_book_publisher(%{"book_id" => book_id, "publisher_id" => publisher_id}) do
        {:ok, book_publisher} ->
          conn
          |> put_view(BooksApiWeb.BooksPublishersJSON)
          |> render("show.json", book_publisher: book_publisher)
        {:error, :book_publisher_exists} ->
          conn
          |> put_status(:conflict)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("409.json", resource: "BookPublisher with this book_id and publisher_id already exists")
        _error ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("422.json", resource: "Invalid data")
      end
    end
    def update(conn, %{"id" => id, "book_id" => book_id, "publisher_id" => publisher_id}) do
      case BooksPublishers.update_book_publisher(id, %{"book_id" => book_id, "publisher_id" => publisher_id}) do
        {:ok, book_publisher} ->
          conn
          |> put_view(BooksApiWeb.BooksPublishersJSON)
          |> render("show.json", book_publisher: book_publisher)
        {:error, :book_publisher_not_found} ->
          conn
          |> put_status(:not_found)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("404.json", resource: "BookPublisher")
        {:error, :book_publisher_exists} ->
          conn
          |> put_status(:conflict)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("409.json", resource: "BookPublisher with this book_id and publisher_id already exists")
        _error ->
          conn
          |> put_status(:unprocessable_entity)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("422.json", resource: "Invalid data")
      end
    end
    def delete(conn, %{"id" => id}) do
      case BooksPublishers.get_book_publisher(id) do
        nil ->
          conn
          |> put_status(:not_found)
          |> put_view(BooksApiWeb.ErrorJSON)
          |> render("404.json", resource: "BookPublisher")
        book_publisher ->
          case BooksPublishers.delete_book_publisher(book_publisher) do
            {:ok, _book_publisher} ->
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
