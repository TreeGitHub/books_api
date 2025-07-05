defmodule BooksApiWeb.UsersController do
  use BooksApiWeb, :controller
  alias BooksApi.Users

  def index(conn, %{"username" => username, "password" => password}) do
    user = Users.get_user(username, password)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})

      {user_id, name} ->
        conn
        |> put_status(:ok)
        |> json(%{
          message: "Login successful",
          user_id: user_id,
          token: "dummy-token",
          name: name
        })
    end
  end

  def create(conn, user_params) do
    user_params = %{
      "name" => user_params["name"],
      "username" => user_params["username"],
      "password_hash" => user_params["password"],
      "email" => user_params["email"]
    }

    case Users.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_view(BooksApiWeb.UsersJSON)
        |> render("show.json", user: user)

      {:error, :user_exists} ->
        conn
        # HTTP 409 Conflict
        |> put_status(:conflict)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("409.json", resource: "User with the same username already exists")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("422.json", errors: changeset.errors)
    end
  end
end
