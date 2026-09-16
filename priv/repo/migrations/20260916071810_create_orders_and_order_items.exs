defmodule BooksApi.Repo.Migrations.CreateOrdersAndOrderItems do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:user_id, references(:users, on_delete: :nothing))
      add(:total_price, :decimal, precision: 10, scale: 2)
      add(:status, :string)

      timestamps()
    end

    create(index(:orders, [:user_id]))

    create table(:order_items) do
      add(:order_id, references(:orders, on_delete: :delete_all))
      add(:book_id, references(:books, on_delete: :nothing))
      add(:quantity, :integer)
      add(:price_paid, :decimal, precision: 10, scale: 2)

      timestamps()
    end

    create(index(:order_items, [:order_id]))
    create(index(:order_items, [:book_id]))
  end
end
