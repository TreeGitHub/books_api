defmodule BooksApiWeb.OrdersController do
  use BooksApiWeb, :controller
  alias BooksApi.Orders

  def index(conn, %{"user_id" => user_id}) do
    orders =
      Orders.list_orders_for_user(user_id)

    conn
    |> put_view(BooksApiWeb.OrdersJSON)
    |> render("index.json", orders: orders)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    order =
      Orders.get_order_for_user(user_id, id)

    conn
    |> put_view(BooksApiWeb.OrdersJSON)
    |> render("show.json", order: order)
  end
end
