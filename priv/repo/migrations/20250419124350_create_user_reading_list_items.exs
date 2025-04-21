defmodule BooksApi.Repo.Migrations.CreateUserReadingListItems do
  use Ecto.Migration

  def change do
    create table(:reading_lists) do
      add(:user_id, references(:users, on_delete: :delete_all))
      add(:book_id, references(:books, on_delete: :delete_all))

      timestamps()
    end
  end
end
