defmodule BooksApi.Controllers.ReadingListsControllerTest do
  use BooksApiWeb.ConnCase, async: true
  alias BooksApi.Books
  alias BooksApi.Users

  @valid_book_attrs %{title: "Elixir in Action", back_cover_summary: "A guide"}
  @valid_user_attrs %{
    "username" => "Tim",
    "name" => "Tim",
    "email" => "tim@gmail.com",
    "password_hash" => "password123"
  }
  setup do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, reading_list} = Users.add_book_to_reading_list(user.id, book.id)
    {:ok, user: user, book: book, reading_list: reading_list}
  end

  test "GET /api/users/:user_id/reading_list returns the user's reading list", %{
    conn: conn,
    user: user,
    book: book
  } do
    conn = get(conn, ~p"/api/users/#{user.id}/reading_list")
    json = json_response(conn, 200)

    assert is_list(json)
    assert Enum.any?(json, fn item -> item["title"] == book.title end)
  end

  test "POST /api/users/:user_id/reading_list adds a book to the user's reading list", %{
    conn: conn,
    user: user,
    book: _book
  } do
    new_book_attrs = %{title: "Programming Phoenix", back_cover_summary: "A guide to Phoenix"}
    {:ok, new_book} = Books.create_book(new_book_attrs)

    conn = post(conn, ~p"/api/users/#{user.id}/reading_list", %{book_id: new_book.id})
    assert conn.status == 201
  end

  test "DELETE /api/users/:user_id/reading_list/:id removes a book from the user's reading list",
       %{
         conn: conn,
         user: user,
         reading_list: reading_list
       } do
    conn = delete(conn, ~p"/api/users/#{user.id}/reading_list/#{reading_list.book_id}")
    assert conn.status == 204
  end

  test "DELETE /api/users/:user_id/reading_list/:id returns 404 if book not found", %{
    conn: conn,
    user: user
  } do
    non_existent_book_id = -1
    conn = delete(conn, ~p"/api/users/#{user.id}/reading_list/#{non_existent_book_id}")
    assert conn.status == 404
  end
end
