defmodule BooksApiWeb.BooksPublishersJSON do
  alias BooksApi.BooksPublishers.BookPublisher

	def index(%{books_publishers: books_publishers}) do
		%{data: for(book_publisher <- books_publishers, do: data(book_publisher))}
	end

	def show(%{book_publisher: book_publisher}) do
		%{data: data(book_publisher)}
	end

	defp data(%BookPublisher{} = book_publisher) do
		%{
      id: book_publisher.id,
			book_id: book_publisher.book_id,
      publisher_id: book_publisher.publisher_id,
			inserted_at: book_publisher.inserted_at,
			updated_at: book_publisher.updated_at
		}
	end
end
