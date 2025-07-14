defmodule BooksApi.BooksAuthorsTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.BooksAuthors
  alias BooksApi.Books
  alias BooksApi.Authors

  @valid_book_attrs %{title: "Elixir in Action", back_cover_summary: "A guide"}
  @valid_author_attrs %{name: "Sasa Juric"}

  test "create_book_author/1 with valid data creates a books_authors" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert books_authors.book_id == book.id
    assert books_authors.author_id == author.id
  end

  test "list_books_authors/0 returns all books_authors" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, _books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert length(BooksAuthors.list_books_authors()) == 1
  end

  test "get_book_author/1 returns the books_authors by id" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert BooksAuthors.get_book_author(books_authors.id).id == books_authors.id
  end

  test "create_book_author/1 with duplicate book_id and author_id returns error :book_author_exists" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, _books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert {:error, :book_author_exists} =
             BooksAuthors.create_book_author(%{
               "book_id" => book.id,
               "author_id" => author.id
             })
  end

  test "update_book_author/2 updates the books_authors" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    {:ok, new_book} = Books.create_book(%{title: "New Book", back_cover_summary: "New Summary"})
    {:ok, new_author} = Authors.create_author(%{name: "New Author"})

    {:ok, updated_books_authors} =
      BooksAuthors.update_book_author(books_authors.id, %{
        "book_id" => new_book.id,
        "author_id" => new_author.id
      })

    assert updated_books_authors.book_id == new_book.id
    assert updated_books_authors.author_id == new_author.id
  end

  test "update_book_author/2 with duplicate book_id and author_id returns error :book_author_exists" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert {:error, :book_author_exists} =
             BooksAuthors.update_book_author(books_authors.id, %{
               "book_id" => book.id,
               "author_id" => author.id
             })
  end

  test "update_book_author/2 with non-existent id returns error :book_author_not_found" do
    assert {:error, :book_author_not_found} = BooksAuthors.update_book_author(-1, %{})
  end

  test "delete_book_author/1 deletes the books_authors" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, books_authors} =
      BooksAuthors.create_book_author(%{
        "book_id" => book.id,
        "author_id" => author.id
      })

    assert {:ok, _} = BooksAuthors.delete_book_author(books_authors)
    assert BooksAuthors.get_book_author(books_authors.id) == nil
  end

  test "create_relationship/2 creates a books_authors relationship" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    assert {:ok, _books_authors} = BooksAuthors.create_relationship(book.id, author.id)
  end

  test "create_relationship/2 with existing relationship returns error :book_author_exists" do
    {:ok, book} = Books.create_book(@valid_book_attrs)
    {:ok, author} = Authors.create_author(@valid_author_attrs)

    {:ok, _books_authors} = BooksAuthors.create_relationship(book.id, author.id)

    assert {:error, :duplicate_relationship} =
             BooksAuthors.create_relationship(book.id, author.id)
  end
end
