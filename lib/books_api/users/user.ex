defmodule BooksApi.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    field(:email, :string)
    field(:password_hash, :string)

    has_many(:reading_lists, BooksApi.ReadingLists.ReadingList)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email, :password_hash])
    |> validate_format(:email, ~r/@/, message: "must be a valid email")
  end
end
