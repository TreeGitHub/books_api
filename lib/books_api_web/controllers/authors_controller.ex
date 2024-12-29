defmodule BooksApiWeb.AuthorsController do
  use Phoenix.Controller, formats: [:json]
  alias BooksApi.Authors

  @doc """
  Lists all authors.
  """
  def index(conn, _params) do
    authors = Authors.list_authors()
    conn
    |> put_view(BooksApiWeb.AuthorsJson)
    |> render("index.json", authors: authors)
  end

  @doc """
  Creates a new author.
  """
  def create(conn, %{"name" => name}) do
    author_params = %{"name" => name}

    case Authors.create_author(author_params) do
      {:ok, author} ->
        conn
        |> put_status(:created)
        |> put_view(BooksApiWeb.AuthorsJson)
        |> render("show.json", author: author)

      {:error, :author_exists} ->
        conn
        |> put_status(:conflict) # HTTP 409 Conflict
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "Author with the same name already exists")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("422.json", errors: changeset.errors)
    end
  end

  @doc """
  Shows a specific author.
  """
  def show(conn, %{"id" => id}) do
    case Authors.get_author(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Author")

      author ->
        conn
        |> put_view(BooksApiWeb.AuthorsJson)
        |> render("show.json", author: author)
    end
  end

  @doc """
  Deletes a specific author.
  """
  def delete(conn, %{"id" => id}) do
    case Authors.get_author(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Author")

      author ->
        case Authors.delete_author(author) do
          {:ok, _author} ->
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

  @doc """
  Updates a specific author.
  """
  def update(conn, %{"id" => id, "author" => author_params}) do
    case Authors.update_author(id, author_params) do
      {:ok, author} ->
        conn
        |> put_view(BooksApiWeb.AuthorsJson)
        |> render("show.json", author: author)

      {:error, :author_not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Author")

      {:error, :author_exists} ->
        conn
        |> put_status(:conflict)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "Author with this name already exists")

      {:error, :unprocessable_entity} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "No changes detected"})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("422.json", changeset: changeset)
    end
  end
end
