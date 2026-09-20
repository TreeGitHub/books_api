defmodule BooksApiWeb.OrdersJSON do
  alias BooksApi.Orders.Order
  alias BooksApi.OrderItems.OrderItem

  def index(%{orders: orders}) do
    IO.inspect(orders, label: "👀 orders passed to index/1")

    # No need to map to order.book manually
    Enum.map(orders, &data/1)
  end

  def show(%{order: order}) do
    detail_data(order)
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

  defp detail_data(%Order{} = order) do
    data(order)
    |> Map.put(:items, Enum.map(order.order_items, &item_data/1))
  end

  defp item_data(%OrderItem{} = item) do
    %{
      id: item.id,
      book_id: item.book_id,
      title: item.book.title,
      quantity: item.quantity,
      price_paid: item.price_paid,
      front_cover_image: item.book.front_cover_image,
      price: item.book.price
    }
  end
end
