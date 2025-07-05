defmodule BooksApiWeb.UsersJSON do
  alias BooksApi.Users.User

  def show(%{user: user}) do
    data(user)
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      name: user.name,
      username: user.username,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
