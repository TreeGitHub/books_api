defmodule BooksApi.Authors do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.Authors.Author
  def list_authors do
    Repo.all(Author)
  end
  def get_author!(id) do
    Repo.get!(Author, id)
  end
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end
  def update_author(id, attrs) do
    author = Repo.get(Author, id)
    case author do
      _author ->
        author
        |> Author.changeset(attrs)
        |> Repo.update()

    end
  end
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end
  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end
end
