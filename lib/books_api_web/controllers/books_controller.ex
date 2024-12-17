defmodule BooksApiWeb.BooksController do
	use Phoenix.Controller, formats: [:json]
	alias BooksApi.Books

	def index(conn, _params) do
		books = Books.list_books()
		conn
		|> put_view(BooksApiWeb.BooksJSON)
		|> render("index.json", books: books)
	end
	def create(conn,  book_params) do
		case Books.create_book(book_params) do
			{:ok, book} ->
				conn
        |> put_view(BooksApiWeb.BooksJSON)  # Explicitly use AuthorsJson here
        |> render("show.json", book: book)
			{:error, changeset} ->
				conn
				|> put_status(:unprocessable_entity)
				|> put_view(BooksApiWeb.ErrorJSON)
				|> render("422.json", changeset: changeset)
			end
	end
	def show(conn, %{"id" => id}) do
		case Books.get_book(id) do
			nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Book")
			book ->
				conn
        |> put_view(BooksApiWeb.BooksJSON)  # Explicitly use AuthorsJson here
        |> render("show.json", book: book)
		end
	end
	def delete(conn, %{"id" => id}) do
    case Books.get_book(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Book")
      book ->
        case Books.delete_book(book) do
          {:ok, _book} ->
            conn
            |> send_resp(:no_content, "")  # Return 204 No Content for successful deletion

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Unable to delete book"})
        end
    end
  end
	def update(conn, %{"id" =>id, "book" => book_params}) do
		case Books.get_book(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Book")
      _book ->
				case Books.update_book(id, book_params) do
					{:ok, book} ->
						conn
						|> put_view(BooksApiWeb.BooksJSON)  # Explicitly use AuthorsJson here
						|> render("show.json", book: book)
				end
		end
	end
end
