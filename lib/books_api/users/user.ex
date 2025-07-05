defmodule BooksApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:username, :string)
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)

    has_many(:reading_lists, BooksApi.ReadingLists.ReadingList)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :name, :email, :password_hash])
    |> validate_required([:username, :email, :password_hash])
    |> validate_format(:email, ~r/@/, message: "must be a valid email")
    |> unique_constraint(:username, message: "Username must be unique")
  end
end
