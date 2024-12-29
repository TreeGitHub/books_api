defmodule BooksApiWeb.PublishersJson do
  alias BooksApi.Publishers.Publisher

	def index(%{publishers: publishers}) do
		%{data: for(publisher <- publishers, do: data(publisher))}
	end
  def show(%{publisher: publisher}) do
    %{data: data(publisher)}
  end

  defp data(%Publisher{} = publisher) do
    %{
      id: publisher.id,
      name: publisher.name,
      address: publisher.address,
      phone_number: publisher.phone_number,
      website: publisher.website,
      inserted_at: publisher.inserted_at,
      updated_at: publisher.updated_at
    }
  end
end
