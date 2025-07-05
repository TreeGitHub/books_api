defmodule BooksApi.Users do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.ReadingLists.ReadingList
  alias BooksApi.Users.User

  def list_books_in_reading_list(user_id) do
    ReadingList
    |> where([r], r.user_id == ^user_id)
    |> preload(book: [:authors])
    |> Repo.all()
  end

  def get_user(username, password) do
    from(u in "users",
      where: u.username == ^username and u.password_hash == ^password,
      select: {u.id, u.name}
    )
    |> Repo.one()
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> case do
      %{valid?: true} = changeset ->
        name = attrs["name"]
        username = attrs["username"]
        email = attrs["email"]
        password_hash = attrs["password_hash"]

        case Repo.get_by(User, username: username) do
          nil -> Repo.insert(changeset)
          _existing_user -> {:error, :user_exists}
        end

      changeset ->
        {:error, changeset}
    end
  end

  def add_book_to_reading_list(user_id, book_id) do
    %ReadingList{}
    |> ReadingList.changeset(%{user_id: user_id, book_id: book_id})
    |> Repo.insert()
  end

  def remove_book_from_reading_list(user_id, book_id) do
    ReadingList
    |> where([r], r.user_id == ^user_id and r.book_id == ^book_id)
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      entry -> Repo.delete(entry)
    end
  end
end
