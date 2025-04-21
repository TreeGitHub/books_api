defmodule BooksApi.Users do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.ReadingLists.ReadingList

  def list_books_in_reading_list(user_id) do
    ReadingList
    |> where([r], r.user_id == ^user_id)
    |> preload(book: [:authors])
    |> Repo.all()
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
