defmodule BooksApiWeb.ReadingListJSON do
  alias BooksApi.Books.Book
  alias BooksApi.ReadingLists.ReadingList

  def index(%{reading_lists: reading_lists}) do
    IO.inspect(reading_lists, label: "👀 reading_lists passed to index/1")

    # No need to map to reading_list.book manually
    Enum.map(reading_lists, &data/1)
  end

  def show(%{reading_list: reading_list}) do
    data(reading_list)
  end

  # 🎯 Handle ReadingList by delegating to the Book
  defp data(%ReadingList{book: %Book{} = book}) do
    data(book)
  end

  # 🎯 Handle Book directly
  defp data(%Book{} = book) do
    IO.inspect(book, label: "📘 Book passed to data/1")

    %{
      id: book.id,
      title: book.title,
      authors:
        Enum.map(book.authors, fn author ->
          %{
            id: author.id,
            name: author.name
          }
        end),
      inserted_at: book.inserted_at,
      updated_at: book.updated_at,
      back_cover_summary: book.back_cover_summary,
      front_cover_image: book.front_cover_image,
      genre: book.genre,
      price: book.price,
      rating: book.rating
    }
  end
end
