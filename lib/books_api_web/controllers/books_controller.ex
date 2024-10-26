defmodule BooksApiWeb.BooksController do
	use Phoenix.Controller, formats: [:json]
	alias BooksApi.Books

	def index(conn, _params) do
		books = %{books: Books.list_books()}
		render(conn, :index, books)
	end
end
