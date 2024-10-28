defmodule BooksApiWeb.BooksJSON do
	alias BooksApi.Books.Book

	def index(%{books: books}) do
		%{data: for(book <- books, do: data(book))}
	end

	def show(%{book: book}) do
		%{data: data(book)}
	end

	defp data(%Book{} = book) do
		%{
			id: book.id,
			title: book.title,
			tagline: book.tagline,
			summary: book.summary,
			inserted_at: book.inserted_at,
			updated_at: book.updated_at
		}
	end
end
