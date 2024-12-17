defmodule BooksApiWeb.AuthorController do
	use Phoenix.Controller, formats: [:json]
  alias BooksApi.Authors

  def index(conn, _params) do
    authors = Authors.list_authors()
    conn
    |> put_view(BooksApiWeb.AuthorsJson) # Explicitly set the view
    |> render("index.json", authors: authors)
  end
  def create(conn, %{"name" => name}) do
    case Authors.create_author(%{"name" => name}) do
      {:ok, author} ->
        conn
        |> put_view(BooksApiWeb.AuthorsJson)  # Explicitly use AuthorsJson here
        |> render("show.json", author: author)
      end
  end
  def show(conn, %{"id" => id}) do
		case Authors.get_author!(id) do
			author ->
				conn
        |> put_view(BooksApiWeb.AuthorsJson)  # Explicitly use AuthorsJson here
        |> render("show.json", author: author)
		end
	end
  def delete(conn, %{"id" => id}) do
    case Authors.get_author!(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Author not found"})

      author ->
        case Authors.delete_author(author) do
          {:ok, _author} ->
            conn
            |> send_resp(:no_content, "")  # Return 204 No Content for successful deletion

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Unable to delete author"})
        end
    end
  end
  def update(conn, %{"id" =>id, "author" => author_params}) do
		case Authors.update_author(id, author_params) do
			{:ok, author} ->
				conn
        |> put_view(BooksApiWeb.AuthorsJson)  # Explicitly use AuthorsJson here
        |> render("show.json", author: author)
		end
	end
end
