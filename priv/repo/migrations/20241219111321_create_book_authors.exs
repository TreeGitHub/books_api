defmodule BooksApi.Repo.Migrations.CreateBookAuthors do
  use Ecto.Migration

  def change do
    create table(:books_authors) do
      add :book_id, references(:books, on_delete: :delete_all)
      add :author_id, references(:authors, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:books_authors, [:book_id, :author_id])
  end
end
