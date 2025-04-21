defmodule BooksApiWeb.ReadingListsController do
  use BooksApiWeb, :controller
  alias BooksApi.Users

  def index(conn, %{"user_id" => user_id}) do
    reading_list = Users.list_books_in_reading_list(user_id)

    conn
    |> put_view(BooksApiWeb.ReadingListJSON)
    |> render("index.json", reading_lists: reading_list)
  end

  def create(conn, %{"user_id" => user_id, "book_id" => book_id}) do
    case Users.add_book_to_reading_list(user_id, book_id) do
      {:ok, _entry} ->
        send_resp(conn, :created, "")

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def delete(conn, %{"user_id" => user_id, "id" => book_id}) do
    case Users.remove_book_from_reading_list(user_id, book_id) do
      {:ok, _} -> send_resp(conn, :no_content, "")
      {:error, _} -> send_resp(conn, :not_found, "")
    end
  end
end
