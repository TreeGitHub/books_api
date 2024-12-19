defmodule BooksApiWeb.BooksAuthorsJSON do
  alias BooksApi.BooksAuthors.BookAuthor

	def index(%{books_authors: books_authors}) do
		%{data: for(book_author <- books_authors, do: data(book_author))}
	end

	def show(%{book_author: book_author}) do
		%{data: data(book_author)}
	end

	defp data(%BookAuthor{} = book_author) do
		%{
      id: book_author.id,
			book_id: book_author.book_id,
      author_id: book_author.author_id,
			inserted_at: book_author.inserted_at,
			updated_at: book_author.updated_at
		}
	end
end
