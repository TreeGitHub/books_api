defmodule BooksApi.Contollers.AuthorsControllerTest do
  use BooksApiWeb.ConnCase, async: true
  alias BooksApi.Authors

  @author_attrs %{
    "name" => "Sasa Juric"
  }

  setup do
    {:ok, author} = Authors.create_author(@author_attrs)
    {:ok, author: author}
  end

  test "GET /api/authors returns authors", %{conn: conn, author: author} do
    conn = get(conn, ~p"/api/authors")
    json = json_response(conn, 200)

    assert is_list(json)
    assert length(json) > 0

    found_author = Enum.find(json, fn a -> a["name"] == author.name end)
    assert found_author
  end

  test "GET /api/authors/:id returns author", %{conn: conn, author: author} do
    conn = get(conn, ~p"/api/authors/#{author.id}")
    json = json_response(conn, 200)

    assert json["name"] == author.name
  end

  test "GET /api/authors/:id returns 404 for non-existing author", %{conn: conn} do
    conn = get(conn, ~p"/api/authors/999999")
    assert response(conn, 404)
  end

  test "POST /api/authors creates a duplicate author", %{conn: conn} do
    conn = post(conn, ~p"/api/authors", @author_attrs)

    assert conn.status == 409

    assert json_response(conn, 409)["errors"]["detail"] ==
             "Author with the same name already exists"
  end

  test "POST /api/authors creates a new author", %{conn: conn} do
    new_author = %{"name" => "Unique Author Name"}

    conn = post(conn, ~p"/api/authors", new_author)
    json = json_response(conn, 201)

    assert json["name"] == new_author["name"]
  end

  test "POST /api/authors returns 422 for invalid data", %{conn: conn} do
    invalid_author = %{"name" => ""}

    conn = post(conn, ~p"/api/authors", invalid_author)
    json = json_response(conn, 422)

    assert json["errors"]["detail"] == "An unknown error occurred"
  end

  test "DELETE /api/authors/:id deletes an author", %{conn: conn, author: author} do
    conn = delete(conn, ~p"/api/authors/#{author.id}")
    assert response(conn, 204)

    # Verify the author is deleted
    conn = get(conn, ~p"/api/authors/#{author.id}")
    assert response(conn, 404)
  end

  test "DELETE /api/authors/:id returns 404 for non-existing author", %{conn: conn} do
    conn = delete(conn, ~p"/api/authors/999999")
    assert response(conn, 404)
    assert json_response(conn, 404)["errors"]["detail"] == "Author not found"
  end

  test "PUT /api/authors/:id updates an author", %{conn: conn, author: author} do
    updated_attrs = %{"name" => "Updated Author Name"}

    conn = put(conn, ~p"/api/authors/#{author.id}", %{"author" => updated_attrs})
    json = json_response(conn, 200)

    assert json["name"] == updated_attrs["name"]
  end

  test "PUT /api/authors/:id returns 404 for non-existing author", %{conn: conn} do
    updated_attrs = %{"name" => "Updated Author Name"}

    conn = put(conn, ~p"/api/authors/999999", %{"author" => updated_attrs})
    assert response(conn, 404)
    assert json_response(conn, 404)["errors"]["detail"] == "Author not found"
  end

  test "PUT /api/authors/:id returns 422 for invalid data", %{conn: conn, author: author} do
    invalid_attrs = %{"name" => ""}

    conn = put(conn, ~p"/api/authors/#{author.id}", %{"author" => invalid_attrs})
    json = json_response(conn, 422)
    assert response(conn, 422)
    assert json["errors"]["name"] == ["can't be blank"]
  end

  test "PUT /api/authors/:id returns 422 for duplicate author", %{conn: conn, author: author} do
    # Create another author to test duplicate name
    {:ok, _duplicate_author} = Authors.create_author(%{"name" => "Duplicate Author"})

    conn =
      put(conn, ~p"/api/authors/#{author.id}", %{"author" => %{"name" => "Duplicate Author"}})

    json = json_response(conn, 409)

    assert json["errors"]["detail"] == "Author with this name already exists"
  end
end
