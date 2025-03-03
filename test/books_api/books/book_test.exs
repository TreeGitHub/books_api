defmodule BooksApi.Books.BookTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Books.Book

  describe "changeset/2" do
    @valid_attrs %{
      title: "Elixir in Action",
      back_cover_summary: "A comprehensive guide to Elixir programming language"
    }
    @invalid_attrs %{
      title: nil,
      back_cover_summary: "A comprehensive guide to Elixir programming language"
    }

    test "with valid attributes" do
      changeset = Book.changeset(%Book{}, @valid_attrs)
      assert changeset.valid?
    end

    test "with invalid attributes" do
      changeset = Book.changeset(%Book{}, @invalid_attrs)
      refute changeset.valid?
    end

    test "requires title" do
      changeset = Book.changeset(%Book{}, Map.delete(@valid_attrs, :title))
      refute changeset.valid?
      assert "can't be blank" in errors_on(changeset).title
    end
  end
end
