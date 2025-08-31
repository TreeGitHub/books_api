defmodule BooksApi.HellgateClient do
  @moduledoc """
  Minimal Hellgate client using HTTPoison.
  """

  def create_checkout_session(cart) do
    api_key = Application.fetch_env!(:books_api, :hellgate)[:api_key]
    api_base = Application.fetch_env!(:books_api, :hellgate)[:api_base]

    body =
      %{
        items:
          Enum.map(cart, fn item ->
            %{
              name: item["title"],
              amount: parse_price(item["price"])
            }
          end)
      }
      |> Jason.encode!()

    headers = [
      {"x-api-key", api_key},
      {"Content-Type", "application/json"}
    ]

    # POST to Hellgate sandbox
    api_base
    |> Kernel.<>("/tokens/session")
    |> HTTPoison.post(body, headers)
    |> handle_response()
  end

  defp parse_price(price) when is_binary(price) do
    case Float.parse(String.replace(price, "$", "")) do
      {val, _} -> val
      _ -> 0.0
    end
  end

  defp parse_price(price) when is_number(price), do: price
  defp parse_price(_), do: 0.0

  defp handle_response({:ok, %HTTPoison.Response{status_code: 201, body: body}}) do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    {:error, %{status: code, body: body}}
  end

  defp handle_response({:error, reason}), do: {:error, reason}
end
