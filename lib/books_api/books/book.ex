defmodule BooksApi.Books.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field(:title, :string)
    field(:back_cover_summary, :string)
    field(:price, :string)
    field(:front_cover_image, :string)
    field(:genre, :string)
    field(:rating, :float)

    # Establish the relationship with BooksAuthors and Authors
    has_many(:books_authors, BooksApi.BooksAuthors.BookAuthor)
    has_many(:authors, through: [:books_authors, :author])
    has_many(:reading_lists, BooksApi.ReadingLists.ReadingList)

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :back_cover_summary, :price, :front_cover_image, :genre, :rating])
    |> validate_required([:title])
  end
end
