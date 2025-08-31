defmodule BooksApiWeb.CheckoutController do
  use BooksApiWeb, :controller
  alias BooksApi.HellgateClient

  def create(conn, %{"cart" => cart}) do
    case HellgateClient.create_checkout_session(cart) do
      {:ok, %{"session_id" => session_id}} ->
        json(conn, %{session_id: session_id})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end
end
