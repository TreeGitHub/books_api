defmodule BooksApi.Repo.Migrations.AddUniqueConstraintToAuthors do
  use Ecto.Migration

  def change do
    create unique_index(:authors, [:name])
  end
end
