defmodule BooksApiWeb.PublishersController do
  use Phoenix.Controller, formats: [:json]
  alias BooksApi.Publishers

  @doc """
  Lists all publishers.
  """
  def index(conn, _params) do
    publishers = Publishers.list_publishers()
    conn
    |> put_view(BooksApiWeb.PublishersJson)
    |> render("index.json", publishers: publishers)
  end

  @doc """
  Creates a new publisher.
  """
 def create(conn, %{"name" => name, "address" => address, "phone_number" => phone_number, "website" => website}) do
  publisher_params = %{"name" => name, "address" => address, "phone_number" => phone_number, "website" => website}

  case Publishers.create_publisher(publisher_params) do
    {:ok, publisher} ->
      conn
      |> put_status(:created)
      |> put_view(BooksApiWeb.PublishersJson)
      |> render("show.json", publisher: publisher)

    {:error, :publisher_exists} ->
      conn
      |> put_status(:conflict) # HTTP 409 Conflict
      |> put_view(BooksApiWeb.ErrorJSON)
      |> render("409.json", resource: "Publisher with the same name already exists")

    {:error, changeset} ->
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(BooksApiWeb.ErrorJSON)
      |> render("422.json", errors: changeset.errors)
  end
end

  @doc """
  Shows a specific publisher.
  """
  def show(conn, %{"id" => id}) do
    case Publishers.get_publisher(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Publisher")

      publisher ->
        conn
        |> put_view(BooksApiWeb.PublishersJson)
        |> render("show.json", publisher: publisher)
    end
  end

  @doc """
  Deletes a specific publisher.
  """
  def delete(conn, %{"id" => id}) do
    case Publishers.get_publisher(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Publisher")

      publisher ->
        case Publishers.delete_publisher(publisher) do
          {:ok, _publisher} ->
            conn
            |> put_status(:no_content)
            |> send_resp(:no_content, "")

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Unable to delete publisher"})
        end
    end
  end

  @doc """
  Updates a specific publisher.
  """
  def update(conn, %{"id" => id, "publisher" => publisher_params}) do
    case Publishers.update_publisher(id, publisher_params) do
      {:ok, publisher} ->
        conn
        |> put_view(BooksApiWeb.PublishersJson)
        |> render("show.json", publisher: publisher)

      {:error, :publisher_not_found} ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Publisher")

      {:error, :publisher_exists} ->
        conn
        |> put_status(:conflict)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "Publisher with this name already exists")

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
