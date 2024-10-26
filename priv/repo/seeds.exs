alias BooksApi.Books

# Read books from the JSON file
books_path = "priv/repo/books.json"
books_path
|> File.read!()
|> Jason.decode!()
|> Enum.each(fn attrs ->
	# Construct a book struct and attempt to insert it
	book = %{title: attrs["title"], tagline: attrs["tagline"], summary: attrs["summary"]}
	case Books.create_book(book) do
		{:ok, _book} -> :ok
		{:error, _changeset} -> :duplicate
	end
end)
