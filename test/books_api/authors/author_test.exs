defmodule BooksApi.Authors.AuthorTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Authors.Author

  describe "changeset/2" do
    test "valid changeset with valid attributes" do
      valid_attrs = %{"name" => "Jane Austen"}

      changeset = Author.changeset(%Author{}, valid_attrs)

      assert changeset.valid?
      assert changeset.changes.name == "Jane Austen"
    end

    test "invalid changeset without name" do
      invalid_attrs = %{}

      changeset = Author.changeset(%Author{}, invalid_attrs)

      refute changeset.valid?
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "unique constraint on name" do
      existing_author = %{name: "Mark Twain"}

      # Insert the existing author
      {:ok, _author} = BooksApi.Repo.insert(Author.changeset(%Author{}, existing_author))

      # Attempt to insert a duplicate author
      duplicate_author = Author.changeset(%Author{}, existing_author)

      {:error, changeset} = BooksApi.Repo.insert(duplicate_author)

      # Match the full error structure, including the :constraint_name
      assert changeset.errors[:name] == {"Author name must be unique", [{:constraint, :unique}, {:constraint_name, "authors_name_index"}]}
    end
  end
end
