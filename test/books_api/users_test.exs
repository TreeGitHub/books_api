defmodule BooksApi.UsersTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Users
  alias BooksApi.Books
  alias BooksApi.Authors
  alias BooksApi.BooksAuthors

  @valid_book_attrs %{title: "Elixir in Action", back_cover_summary: "A guide"}
  @valid_user_attrs %{
    "username" => "Tim",
    "name" => "Tim",
    "email" => "tim@gmail.com",
    "password_hash" => "password123"
  }
  @valid_author_attrs %{name: "Sasa Juric"}
  @invalid_user_attrs %{
    "username" => "",
    "name" => "Tim",
    "email" => "tim@gmail.com",
    "password_hash" => "password123"
  }

  test "list_books_in_reading_list/1 returns the user's reading list" do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, _books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    {:ok, _reading_list} = Users.add_book_to_reading_list(user.id, book.id)
    reading_list = Users.list_books_in_reading_list(user.id)

    assert length(reading_list) == 1
    assert hd(reading_list).user_id == user.id
    assert hd(reading_list).book_id == book.id
  end

  test "get_user/2 returns the user by username and password" do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    fetched_user = Users.get_user(user.username, user.password_hash)

    assert fetched_user == {user.id, user.name}
  end

  test "create_user/1 returns an error when username is already taken" do
    {:ok, _user} = Users.create_user(@valid_user_attrs)
    assert {:error, :user_exists} = Users.create_user(@valid_user_attrs)
  end

  test "create_user/1 returns an error when email is already taken" do
    {:error, _changeset} = Users.create_user(@invalid_user_attrs)
  end

  test "remove_book_from_reading_list/2 removes a book from the user's reading list" do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    {:ok, book} = Books.create_book(@valid_book_attrs)

    {:ok, _reading_list} = Users.add_book_to_reading_list(user.id, book.id)
    assert length(Users.list_books_in_reading_list(user.id)) == 1

    {:ok, _} = Users.remove_book_from_reading_list(user.id, book.id)
    assert length(Users.list_books_in_reading_list(user.id)) == 0
  end

  test "remove_book_from_reading_list/2 returns an error if book is not in reading list" do
    {:ok, user} = Users.create_user(@valid_user_attrs)

    assert {:error, :not_found} = Users.remove_book_from_reading_list(user.id, -1)
  end
end
