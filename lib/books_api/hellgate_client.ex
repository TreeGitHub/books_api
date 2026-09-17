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
              name: item.title,
              amount: parse_price(item.price)
            }
          end)
      }
      |> IO.inspect(label: "hellgate body")
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

  def get_token_status(token_id) do
    api_key = Application.fetch_env!(:books_api, :hellgate)[:api_key]
    api_base = Application.fetch_env!(:books_api, :hellgate)[:api_base]

    headers = [
      {"x-api-key", api_key},
      {"Content-Type", "application/json"}
    ]

    api_base
    |> Kernel.<>("/tokens/#{token_id}")
    |> HTTPoison.get(headers)
    |> handle_response()
  end

  def request_payment_data(token_id, amount_cents, reference) do
    api_key = Application.fetch_env!(:books_api, :hellgate)[:api_key]
    api_base = Application.fetch_env!(:books_api, :hellgate)[:api_base]
    merchant_id = Application.fetch_env!(:books_api, :hellgate)[:merchant_id]

    body =
      %{
        amount: amount_cents,
        currency_code: "USD",
        reference: reference,
        merchant_id: merchant_id
      }
      |> Jason.encode!()

    headers = [
      {"x-api-key", api_key},
      {"Content-Type", "application/json"}
    ]

    api_base
    |> Kernel.<>("/tokens/#{token_id}/payment-data")
    |> HTTPoison.post(body, headers)
    |> handle_response()
  end

  def forward_payment_data(payment_data_id, reference) do
    # TEMPORARY MOCK — sandbox forward-payment-data auth is unreliable (known Hellgate sandbox limitation).
    # Real implementation commented out below; restore it once testing against a working environment.
    {:ok, %{"success" => true, "reference" => reference, "mocked" => true}}

    # api_base = Application.fetch_env!(:books_api, :hellgate)[:api_base]
    # merchant_account = Application.fetch_env!(:books_api, :hellgate)[:merchant_account]
    # merchant_api_key = Application.fetch_env!(:books_api, :hellgate)[:merchant_api_key]

    # amount = %{
    #   "value" => "{{ amount }}",
    #   "currency" => "{{ currency_code }}"
    # }

    # mpi_data = %{
    #   "tokenAuthenticationVerificationValue" => "{{ cryptogram }}",
    #   "eci" => "{{ eci }}"
    # }

    # payment_method = %{
    #   "type" => "networkToken",
    #   "number" => "{{ network_token }}",
    #   "expiryMonth" => "{{ expiration_month }}",
    #   "expiryYear" => "{{ expiration_year }}"
    # }

    # body =
    #   %{
    #     "merchantAccount" => merchant_account,
    #     "reference" => reference,
    #     "amount" => amount,
    #     "paymentMethod" => payment_method,
    #     "mpiData" => mpi_data,
    #     "recurringProcessingModel" => "CardOnFile",
    #     "shopperInteraction" => "ContAuth"
    #   }
    #   |> Jason.encode!()

    # headers = [
    #   {"x-api-key", merchant_api_key},
    #   {"Content-Type", "application/json"}
    # ]

    # api_base
    # |> Kernel.<>("/payment-data/#{payment_data_id}/forward")
    # |> HTTPoison.post(body, headers)
    # |> handle_response()
  end

  defp parse_price(price) when is_binary(price) do
    case Float.parse(String.replace(price, "$", "")) do
      {val, _} -> val
      _ -> 0.0
    end
  end

  defp parse_price(price) when is_number(price), do: price
  defp parse_price(_), do: 0.0

  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}})
       when code in [200, 201] do
    {:ok, Jason.decode!(body)}
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: code, body: body}}) do
    {:error, %{status: code, body: body}}
  end

  defp handle_response({:error, reason}), do: {:error, reason}
end
