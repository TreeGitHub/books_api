defmodule BooksApi.Repo.Migrations.CreateBooksPublishers do
  use Ecto.Migration

  def change do
    create table(:books_publishers) do
      add :book_id, references(:books, on_delete: :delete_all)
      add :publisher_id, references(:publishers, on_delete: :delete_all)
      timestamps()
    end

    create unique_index(:books_publishers, [:book_id, :publisher_id])
  end
end
