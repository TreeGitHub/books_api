defmodule BooksApi.Orders do
  import Ecto.Query, warn: false
  alias BooksApi.Repo
  alias BooksApi.Orders.Order
  alias BooksApi.OrderItems.OrderItem

  def parse_price_to_cents(price) do
    {value, _} = Float.parse(String.replace(price, "$", ""))
    round(value * 100)
  end

  def create_order(user_id, books, total_cents, reference, status) do
    order_changeset =
      %Order{}
      |> Order.changeset(%{
        user_id: user_id,
        total_price: total_cents / 100,
        status: status
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:order, order_changeset)
    |> Ecto.Multi.run(:order_items, fn repo, %{order: order} ->
      results =
        Enum.map(books, fn book ->
          %OrderItem{}
          |> OrderItem.changeset(%{
            order_id: order.id,
            book_id: book.id,
            quantity: 1,
            price_paid: parse_price_to_cents(book.price) / 100
          })
          |> repo.insert()
        end)

      if Enum.all?(results, fn {status, _} -> status == :ok end) do
        {:ok, Enum.map(results, fn {:ok, item} -> item end)}
      else
        {:error, "Failed to create one or more order items"}
      end
    end)
    |> Repo.transaction()
  end
end
