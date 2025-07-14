defmodule BooksApiWeb.BooksControllerTest do
  use BooksApiWeb.ConnCase, async: true

  alias BooksApi.{Books, Authors, BooksAuthors}

  @book_attrs %{
    "title" => "Elixir in Action",
    "back_cover_summary" => "A great Elixir book",
    "price" => "29.99",
    "front_cover_image" => "cover.jpg",
    "genre" => "Programming",
    "rating" => 5
  }

  @author_attrs %{
    "name" => "Sasa Juric"
  }

  setup do
    # Create author
    {:ok, author} = Authors.create_author(@author_attrs)

    # Create book
    {:ok, book} = Books.create_book(@book_attrs)

    # Associate book with author
    {:ok, _relation} = BooksAuthors.create_relationship(book.id, author.id)

    # Return data to be used in tests
    {:ok, %{book: book, author: author}}
  end

  test "GET /api/books returns books with authors", %{conn: conn, book: book, author: author} do
    conn = get(conn, ~p"/api/books")
    json = json_response(conn, 200)

    assert conn.status == 200
    assert is_list(json)
    assert length(json) > 0

    found_book =
      Enum.find(json, fn b -> b["title"] == book.title end)

    assert found_book
    assert Enum.any?(found_book["authors"], fn a -> a["name"] == author.name end)
  end

  test "GET /api/books/:id returns a book with authors", %{conn: conn, book: book, author: author} do
    conn = get(conn, ~p"/api/books/#{book.id}")
    json = json_response(conn, 200)

    assert conn.status == 200
    assert json["title"] == book.title
    assert Enum.any?(json["authors"], fn a -> a["name"] == author.name end)
  end

  test "GET /api/books/:id returns 404 if book does not exist", %{conn: conn} do
    # Use an ID that doesn’t exist in the database
    non_existent_id = -1

    conn = get(conn, ~p"/api/books/#{non_existent_id}")

    assert response(conn, 404)
    assert json_response(conn, 404)["errors"]["detail"] == "Book not found"
  end

  test "POST /api/books creates a book with authors", %{conn: conn, author: author} do
    # Compose the request body expected by the controller
    book_with_authors =
      Map.put(@book_attrs, "authors", [%{"name" => author.name}])

    # Make the POST request
    conn = post(conn, ~p"/api/books", book_with_authors)

    # Parse and assert response
    json = json_response(conn, 201)

    assert conn.status == 201
    assert json["title"] == @book_attrs["title"]
    assert json["back_cover_summary"] == @book_attrs["back_cover_summary"]
    assert json["price"] == @book_attrs["price"]
    assert json["front_cover_image"] == @book_attrs["front_cover_image"]
    assert json["genre"] == @book_attrs["genre"]
    assert json["rating"] == @book_attrs["rating"]

    assert Enum.any?(json["authors"], fn a -> a["name"] == author.name end)
  end

  test "POST /api/books returns error and rolls back if book creation fails", %{conn: conn} do
    invalid_attrs = %{
      # title is required and can't be nil
      "title" => nil,
      "back_cover_summary" => "Some summary",
      "price" => "19.99",
      "front_cover_image" => "cover.png",
      "genre" => "Sci-Fi",
      "rating" => 5,
      "authors" => [%{"name" => "Author Name"}]
    }

    conn = post(conn, ~p"/api/books", invalid_attrs)
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "DELETE /api/books/:id deletes a book", %{conn: conn, book: book} do
    # Make the DELETE request
    conn = delete(conn, ~p"/api/books/#{book.id}")

    # Assert response status
    assert conn.status == 204
  end

  test "POST /api/books creates a book and creates new author if author does not exist", %{
    conn: conn
  } do
    new_author_name = "Brand New Author"

    book_params = %{
      "title" => "New Book Title",
      "back_cover_summary" => "Summary of the new book",
      "price" => "15.99",
      "front_cover_image" => "new_cover.jpg",
      "genre" => "Fantasy",
      "rating" => 4,
      "authors" => [%{"name" => new_author_name}]
    }

    conn = post(conn, ~p"/api/books", book_params)
    json = json_response(conn, 201)

    assert conn.status == 201
    assert json["title"] == book_params["title"]
    assert Enum.any?(json["authors"], fn a -> a["name"] == new_author_name end)
  end

  test "DELETE /api/books/:id returns 404 if book does not exist", %{conn: conn} do
    # Use an ID that doesn’t exist in the database
    non_existent_id = -1

    conn = delete(conn, ~p"/api/books/#{non_existent_id}")

    assert response(conn, 404)
    assert json_response(conn, 404)["errors"]["detail"] == "Book not found"
  end

  test "PUT /api/books/:id updates a book", %{conn: conn, book: book} do
    updated_attrs = %{
      "title" => "Updated Title",
      "back_cover_summary" => "Updated summary",
      "price" => "19.99",
      "front_cover_image" => "updated_cover.jpg",
      "genre" => "Updated Genre",
      "rating" => 4
    }

    # Wrap updated attributes inside "book"
    conn = put(conn, ~p"/api/books/#{book.id}", %{"book" => updated_attrs})

    json = json_response(conn, 200)

    assert conn.status == 200
    assert json["title"] == updated_attrs["title"]
    assert json["back_cover_summary"] == updated_attrs["back_cover_summary"]
    assert json["price"] == updated_attrs["price"]
    assert json["front_cover_image"] == updated_attrs["front_cover_image"]
    assert json["genre"] == updated_attrs["genre"]
    assert json["rating"] == updated_attrs["rating"]
  end
end
