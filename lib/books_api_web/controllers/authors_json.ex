defmodule BooksApiWeb.AuthorsJson do
  alias BooksApi.Authors.Author

	def index(%{authors: authors}) do
		%{data: for(author <- authors, do: data(author))}
	end
  def show(%{author: author}) do
    %{data: data(author)}
  end

  defp data(%Author{} = author) do
    %{
      id: author.id,
      name: author.name,
      inserted_at: author.inserted_at,
      updated_at: author.updated_at
    }
  end
end
