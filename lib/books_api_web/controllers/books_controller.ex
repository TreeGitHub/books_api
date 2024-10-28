defmodule BooksApiWeb.BooksController do
	use Phoenix.Controller, formats: [:json]
	alias BooksApi.Books

	def index(conn, _params) do
		books = %{books: Books.list_books()}
		render(conn, :index, books)
	end

	def create(conn,  book_params) do
		case Books.create_book(book_params) do
			{:ok, book} ->
				render(conn, :show, book: book)
			end
	end

	def show(conn, %{"id" => id}) do
		case Books.get_book!(id) do
			book ->
				render(conn, :show, book: book)
		end
	end

	def delete(conn, %{"id" => id}) do
		case Books.delete_book(id) do
			{:ok, book} ->
				render(conn, :show, book: book)
		end
	end

	def update(conn, %{"id" =>id, "book" => book_params}) do
		case Books.update_book(id, book_params) do
			{:ok, book} ->
				render(conn, :show, book: book)
		end
	end
end
