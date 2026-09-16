defmodule BooksApi.OrderItems.OrderItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order_items" do
    field(:quantity, :integer)
    field(:price_paid, :decimal)

    timestamps()

    belongs_to(:order, BooksApi.Orders.Order)
    belongs_to(:book, BooksApi.Books.Book)
  end

  @doc false
  def changeset(order_item, attrs) do
    order_item
    |> cast(attrs, [:order_id, :book_id, :quantity, :price_paid])
    |> validate_required([:order_id, :book_id, :quantity, :price_paid])
  end
end
