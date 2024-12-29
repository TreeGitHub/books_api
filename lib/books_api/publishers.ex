defmodule BooksApi.Publishers do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.Publishers.Publisher

  def list_publishers do
    Repo.all(Publisher)
  end
  def get_publisher(id) do
    Repo.get(Publisher, id)
  end
  def find_by_name(name) do
    Repo.get_by(Publisher, name: name)
  end
  def create_publisher(attrs \\ %{}) do
    %Publisher{}
    |> Publisher.changeset(attrs)
    |> case do
      %{valid?: true} = changeset ->
        name = attrs["name"]

        case Repo.get_by(Publisher, name: name) do
          nil -> Repo.insert(changeset)
          _existing_publisher -> {:error, :publisher_exists}
        end

      changeset ->
        {:error, changeset}
    end
  end
  def update_publisher(id, attrs \\ %{}) do
    case Repo.get(Publisher, id) do
      nil ->
        {:error, :publisher_not_found}

      publisher ->
        name = attrs["name"]

        # Check if the new name already exists in the database (excluding the current publisher)
        case Repo.get_by(Publisher, name: name) do
          nil ->
            # Proceed with updating the publisher
            publisher
            |> Publisher.changeset(attrs)
            |> Repo.update()

          _existing_publisher ->
            # The name is already taken by another publisher]
            {:error, :publisher_exists}
        end
    end
  end
  def delete_publisher(%Publisher{} = publisher) do
    Repo.delete(publisher)
  end
  def change_publisher(%Publisher{} = publisher, attrs \\ %{}) do
    Publisher.changeset(publisher, attrs)
  end
  def find_or_create_publisher(%{"name" => name}) do
    case Repo.get_by(Publisher, name: name) do
      nil ->
        %Publisher{}
        |> Publisher.changeset(%{"name" => name})
        |> Repo.insert()

      publisher ->
        {:ok, publisher}
    end
  end
end
