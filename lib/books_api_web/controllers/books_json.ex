defmodule BooksApiWeb.BooksJSON do
	alias BooksApi.Books.Book

	def index(%{books: books}) do
		%{data: for(book <- books, do: data(book))}
	end

	def show(%{book: book}) do
		%{data: data(book)}
	end

	defp data(%Book{} = datum) do
		%{
			title: datum.title,
			tagline: datum.tagline,
			summary: datum.summary
		}
	end
end
