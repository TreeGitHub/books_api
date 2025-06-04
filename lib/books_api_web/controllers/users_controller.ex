defmodule BooksApiWeb.UsersController do
  use BooksApiWeb, :controller
  alias BooksApi.Users

  def index(conn, %{"name" => name, "password" => password}) do
    user = Users.get_user(name, password)

    case user do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})

      user_id ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Login successful", user_id: user_id, token: "dummy-token"})
    end
  end
end
