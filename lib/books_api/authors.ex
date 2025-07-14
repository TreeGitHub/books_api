defmodule BooksApi.Authors do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.Authors.Author
  @spec list_authors() :: any()
  def list_authors do
    Repo.all(Author)
  end

  def get_author(id) do
    Repo.get(Author, id)
  end

  def find_by_name(name) do
    Repo.get_by(Author, name: name)
  end

  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> case do
      %{valid?: true} = changeset ->
        name = Map.get(attrs, "name") || Map.get(attrs, :name)

        case Repo.get_by(Author, name: name) do
          nil -> Repo.insert(changeset)
          _existing_author -> {:error, :author_exists}
        end

      changeset ->
        {:error, changeset}
    end
  end

  def update_author(id, attrs \\ %{}) do
    case Repo.get(Author, id) do
      nil ->
        {:error, :author_not_found}

      author ->
        name = attrs["name"]

        # Check if the new name already exists in the database (excluding the current author)
        case Repo.get_by(Author, name: name) do
          nil ->
            # Proceed with updating the author
            author
            |> Author.changeset(attrs)
            |> Repo.update()

          _existing_author ->
            # The name is already taken by another author
            {:error, :author_exists}
        end
    end
  end

  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  def change_author(%Author{} = author, attrs \\ %{}) do
    Author.changeset(author, attrs)
  end

  def find_or_create_author(%{"name" => name}) do
    case Repo.get_by(Author, name: name) do
      nil ->
        %Author{}
        |> Author.changeset(%{"name" => name})
        |> Repo.insert()

      author ->
        {:ok, author}
    end
  end
end
