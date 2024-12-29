defmodule BooksApi.Repo.Migrations.CreatePublishers do
  use Ecto.Migration

  def change do
    create table(:publishers) do
      add :name, :string, null: false
      add :address, :string
      add :phone_number, :string
      add :website, :string

      timestamps()
    end

    create unique_index(:publishers, [:name]) # Ensure publisher names are unique
  end
end
