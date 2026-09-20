defmodule BooksApiWeb.OrdersJSON do
  alias BooksApi.Orders.Order

  def index(%{orders: orders}) do
    IO.inspect(orders, label: "👀 orders passed to index/1")

    # No need to map to order.book manually
    Enum.map(orders, &data/1)
  end

  def show(%{order: order}) do
    data(order)
  end

  # 🎯 Handle Order directly
  defp data(%Order{} = order) do
    IO.inspect(order, label: "📘 Order passed to data/1")

    %{
      id: order.id,
      status: order.status,
      total_price: order.total_price,
      inserted_at: order.inserted_at,
      reference: order.reference
    }
  end
end
