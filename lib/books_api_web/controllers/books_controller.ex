defmodule BooksApiWeb.BooksController do
	use Phoenix.Controller, formats: [:json]
	alias BooksApi.Books

	def index(conn, _params) do
		books = %{books: Books.list_books()}
		render(conn, :index, books)
	end


	def create(conn,  book_params) do
		Books.create_book(book_params)
		json(conn, %{book: book_params})
	end
end
