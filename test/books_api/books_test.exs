defmodule BooksApi.BooksTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Books

  @valid_attrs %{title: "Elixir in Action", back_cover_summary: "A guide"}
  @update_attrs %{title: "Updated Title"}
  @invalid_attrs %{title: nil, back_cover_summary: nil}

  test "list_books/0 returns all books" do
    {:ok, book} = Books.create_book(@valid_attrs)
    assert Books.list_books() == [book]
  end

  test "list_books/0 returns empty list when no books" do
    assert Books.list_books() == []
  end

  test "get_book/1 returns the book by id" do
    {:ok, book} = Books.create_book(@valid_attrs)
    assert Books.get_book(book.id).id == book.id
  end

  test "create_book/1 with valid data creates a book" do
    assert {:ok, book} = Books.create_book(@valid_attrs)
    assert book.title == "Elixir in Action"
    assert book.back_cover_summary == "A guide"
  end

  test "create_book/1 with invalid data returns error changeset" do
    assert {:error, changeset} = Books.create_book(@invalid_attrs)
    refute changeset.valid?
  end

  test "update_book/2 updates the book" do
    {:ok, book} = Books.create_book(@valid_attrs)
    {:ok, updated} = Books.update_book(book.id, @update_attrs)
    assert updated.title == "Updated Title"
  end

  test "update_book/2 with invalid data returns error changeset" do
    {:ok, book} = Books.create_book(@valid_attrs)
    assert {:error, changeset} = Books.update_book(book.id, @invalid_attrs)
    refute changeset.valid?
    # Ensure the book is unchanged
    assert Books.get_book(book.id).title == "Elixir in Action"
  end

  test "delete_book/1 deletes the book" do
    {:ok, book} = Books.create_book(@valid_attrs)
    assert {:ok, _} = Books.delete_book(book)
    assert Books.get_book(book.id) == nil
  end

  test "change_book/1 returns a changeset" do
    {:ok, book} = Books.create_book(@valid_attrs)
    changeset = Books.change_book(book)
    assert %Ecto.Changeset{} = changeset
    assert changeset.data.id == book.id
  end

  # Optional: Only include if you have this function and associations set up
  test "get_book_with_authors/1 returns book with preloaded authors" do
    {:ok, book} = Books.create_book(@valid_attrs)
    book_with_authors = Books.get_book_with_authors(book.id)
    assert book_with_authors.id == book.id
    assert Map.has_key?(book_with_authors, :authors)
  end
end
