defmodule BooksApiWeb.BooksJSON do
	alias BooksApi.Books.Book
	alias BooksApi.Authors.Author

	def index(%{books: books}) do
		%{data: for(book <- books, do: data(book))}
	end

	def show(%{book: book}) do
		%{data: data(book)}
	end

	  # Converts a Book struct into a map with selected fields
		defp data(%Book{} = book) do
		%{
			id: book.id,
			title: book.title,
			tagline: book.tagline,
			summary: book.summary,
			inserted_at: book.inserted_at,
			updated_at: book.updated_at,
			authors: authors_data(book.authors)  # Include authors data
		}
	end
	defp authors_data(authors) do
    Enum.map(authors || [], fn %Author{name: name, id: id} ->
      %{
        id: id,
        name: name
      }
    end)
  end
end
