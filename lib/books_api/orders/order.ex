defmodule BooksApi.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    belongs_to(:user, BooksApi.Users.User)
    field(:total_price, :decimal)
    field(:status, :string, default: "pending")
    field(:reference, :string)

    has_many(:order_items, BooksApi.OrderItems.OrderItem)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:user_id, :total_price, :status, :reference])
    |> validate_required([:user_id, :total_price, :status])
  end
end
