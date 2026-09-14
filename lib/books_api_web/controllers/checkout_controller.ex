defmodule BooksApiWeb.CheckoutController do
  use BooksApiWeb, :controller
  alias BooksApi.HellgateClient
  alias BooksApi.Books

  def create(conn, %{"cart" => cart}) when is_list(cart) and cart != [] do
    books = Enum.map(cart, fn item -> Books.get_book(item["id"]) end)

    if Enum.any?(books, &is_nil/1) do
      conn
      |> put_status(:not_found)
      |> json(%{error: "One or more books in your cart could not be found"})
    else
      trusted_items = Enum.map(books, fn book -> %{title: book.title, price: book.price} end)

      case HellgateClient.create_checkout_session(trusted_items) do
        {:ok, %{"session_id" => session_id}} ->
          json(conn, %{session_id: session_id})

        {:error, reason} ->
          conn
          |> put_status(:bad_request)
          |> json(%{error: reason})
      end
    end
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid checkout request. Please provide a valid cart."})
  end
end
