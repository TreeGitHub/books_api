defmodule BooksApi.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add(:title, :string)
      add(:back_cover_summary, :text)
      add(:price, :string)
      add(:genre, :string)
      add(:rating, :float)
      add(:front_cover_image, :string)
      timestamps()
    end
  end
end
