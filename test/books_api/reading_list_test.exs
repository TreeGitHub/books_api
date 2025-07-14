defmodule BooksApi.ReadingListTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Books
  alias BooksApi.Users

  @valid_book_attrs %{title: "Elixir in Action", back_cover_summary: "A guide"}
  @valid_user_attrs %{
    "username" => "Tim",
    "name" => "Tim",
    "email" => "tim@gmail.com",
    "password_hash" => "password123"
  }

  test "update_reading_list/2 updates the reading list" do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    {:ok, book} = Books.create_book(@valid_book_attrs)

    {:ok, reading_list} = Users.add_book_to_reading_list(user.id, book.id)

    assert reading_list.user_id == user.id
    assert reading_list.book_id == book.id
  end
end
