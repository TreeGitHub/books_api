defmodule BooksApi.ReadingLists.ReadingList do
  use Ecto.Schema
  import Ecto.Changeset
  alias BooksApi.Users.User
  alias BooksApi.Books.Book

  schema "reading_lists" do
    # Establish the relationships for a users reading list
    belongs_to(:user, User)
    belongs_to(:book, Book)

    timestamps()
  end

  @doc false
  def changeset(reading_lists, attrs) do
    reading_lists
    |> cast(attrs, [:user_id, :book_id])
    |> validate_required([:user_id, :book_id])
  end
end
