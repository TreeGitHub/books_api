defmodule BooksApiWeb.CheckoutController do
  use BooksApiWeb, :controller
  alias BooksApi.HellgateClient
  alias BooksApi.Books

  @reference_words [
    "alpha",
    "bravo",
    "charlie",
    "delta",
    "echo",
    "foxtrot",
    "golf",
    "hotel",
    "india",
    "juliet",
    "kilo",
    "lima",
    "mike",
    "november",
    "oscar",
    "papa",
    "quebec",
    "romeo",
    "sierra",
    "tango",
    "uniform",
    "victor",
    "whiskey",
    "x-ray",
    "yankee",
    "zulu"
  ]

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

  defp parse_price_to_cents(price) do
    {value, _} = Float.parse(String.replace(price, "$", ""))
    round(value * 100)
  end

  def charge(conn, %{"cart" => cart, "token_id" => token_id}) do
    reference = generate_reference()
    books = Enum.map(cart, fn item -> Books.get_book(item["id"]) end)

    total_cents =
      books
      |> Enum.map(fn book -> book.price end)
      |> Enum.map(&parse_price_to_cents/1)
      |> Enum.sum()

    with {:ok, %{"network_token_status" => "active"}} <- HellgateClient.get_token_status(token_id),
         {:ok, %{"id" => payment_data_id}} <-
           HellgateClient.request_payment_data(token_id, total_cents, reference),
         {:ok, forward_result} <- HellgateClient.forward_payment_data(payment_data_id, reference) do
      IO.inspect(forward_result, label: "forward_result")
      json(conn, %{status: "received", forward_result: forward_result})
    else
      error ->
        IO.inspect(error, label: "charge failed")

        conn
        |> put_status(:bad_request)
        |> json(%{error: "Payment could not be processed"})
    end
  end

  defp generate_reference do
    word = Enum.random(@reference_words)
    number = :rand.uniform(9999)
    "KF-#{word}-#{number}"
  end
end
