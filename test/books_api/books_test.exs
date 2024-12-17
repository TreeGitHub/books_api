defmodule BooksApi.BooksTest do
  use BooksApi.DataCase

  alias BooksApi.Books

  describe "books" do
    alias BooksApi.Books.Book
    import BooksApi.BooksFixtures
    @invalid_attrs %{title: nil, tagline: nil, summary: nil}

    test "successfully creates a book" do
      book_params = %{
        title: "Sample Book",
        tagline: "A sample tagline",
        summary: "This is a sample summary"
      }

      assert {:ok, %Book{id: id, title: "Sample Book"}} = Books.create_book(book_params)
      assert id
    end

    test "fails to create a book with missing title" do
      book_params = %{
        tagline: "A sample tagline",
        summary: "This is a sample summary"
      }

      assert {:error, changeset} = Books.create_book(book_params)
      assert changeset.errors[:title]
    end


    test "successfully updates a book" do
      book_params = %{
        title: "Sample Book",
        tagline: "A sample tagline",
        summary: "This is a sample summary"
      }

      {:ok, book} = Books.create_book(book_params)

      updated_params = %{title: "Updated Sample Book"}
      {:ok, updated_book} = Books.update_book(book.id, updated_params)

      assert updated_book.title == "Updated Sample Book"
    end

    test "fails to create book with missing summary" do
      book_params = %{
        title: "Sample Book",
        tagline: "A sample tagline"
      }

      assert {:error, changeset} = Books.create_book(book_params)
      assert changeset.errors[:summary]
    end



  end
end
