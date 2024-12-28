defmodule BooksApiWeb.BooksController do
	use Phoenix.Controller, formats: [:json]
	require Logger
	alias BooksApi.BooksAuthors
	alias BooksApi.{Books, Repo, Authors}

	def index(conn, _params) do
		books = Books.list_books()
					 |> Repo.preload(:authors) # Preload the associated authors

		conn
		|> put_view(BooksApiWeb.BooksJSON)
		|> render("index.json", books: books)
	end
	def create(conn, %{"title" => title, "tagline" => tagline, "summary" => summary, "authors" => authors_params}) do
		book_params = %{"title" => title, "tagline" => tagline, "summary" => summary}

		Repo.transaction(fn ->
			# Create the book
			with {:ok, book} <- Books.create_book(book_params),
					 {:ok, _relations} <- associate_authors_with_book(book, authors_params) do
				book
			else
				{:error, reason} -> Repo.rollback(reason)
			end
		end)
		|> case do
			{:ok, book} ->
				# Preload authors after creation and associate
				book = Books.get_book_with_authors(book.id)

				conn
				|> put_status(:created)
				|> put_view(BooksApiWeb.BooksJSON)
				|> render("show.json", book: book)

			{:error, :author_exists} ->
				conn
				|> put_status(:conflict)
				|> json(%{error: "Author already exists"})

			{:error, :book_creation_failed} ->
				conn
				|> put_status(:unprocessable_entity)
				|> json(%{error: "Book creation failed"})

			{:error, changeset} ->
				conn
				|> put_status(:unprocessable_entity)
				|> put_view(BooksApiWeb.ErrorJSON)
				|> render("422.json", changeset: changeset)
		end
	end
	# Helper function to handle authors
	defp associate_authors_with_book(book, authors_params) do
		Enum.reduce_while(authors_params, {:ok, []}, fn author_param, {:ok, relations} ->
			with {:ok, author} <- find_or_create_author(author_param),
					 {:ok, relation} <- create_author_relationship(book, author) do
				{:cont, {:ok, [relation | relations]}}
			else
				{:error, reason} ->
					Logger.error("Failed to associate author: #{inspect(reason)}")
					{:halt, {:error, reason}}
			end
		end)
	end
	defp find_or_create_author(%{"name" => name} = author_param) do
		case Authors.find_by_name(name) do
			nil -> Authors.create_author(author_param)
			author -> {:ok, author}
		end
	end
	defp create_author_relationship(book, author) do
		BooksAuthors.create_relationship(book.id, author.id)
	end
	def show(conn, %{"id" => id}) do
		case Books.get_book_with_authors(id) do
			nil ->
        conn
        |> put_status(:not_found)
        |> put_view(BooksApiWeb.ErrorJSON)
        |> render("404.json", resource: "Book")
			book ->
				conn
				|> put_view(BooksApiWeb.BooksJSON)  # Explicitly use BooksJSON here
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
