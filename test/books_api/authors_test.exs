defmodule BooksApi.AuthorsTest do
  use BooksApi.DataCase, async: true
  alias BooksApi.Authors

  @valid_attrs %{name: "John Doe"}
  @invalid_attrs %{name: nil}

  test "list_authors/0 returns all authors" do
    {:ok, author} = Authors.create_author(@valid_attrs)
    assert Authors.list_authors() == [author]
  end

  test "list_authors/0 returns empty list when no authors" do
    assert Authors.list_authors() == []
  end

  test "get_author/1 returns the author by id" do
    {:ok, author} = Authors.create_author(@valid_attrs)
    assert Authors.get_author(author.id).id == author.id
  end

  test "find_by_name/1 returns the author by name" do
    {:ok, author} = Authors.create_author(@valid_attrs)
    assert Authors.find_by_name("John Doe") == author
  end

  test "create_author/1 with valid data creates an author" do
    assert {:ok, author} = Authors.create_author(@valid_attrs)
    assert author.name == "John Doe"
  end

  test "create_author/1 with invalid data returns error changeset" do
    assert {:error, changeset} = Authors.create_author(@invalid_attrs)
    refute changeset.valid?
  end

  test "create_author/1 with duplicate name returns error :author_exists" do
    assert {:ok, _author} = Authors.create_author(%{"name" => "John Doe"})
    assert {:error, :author_exists} = Authors.create_author(%{"name" => "John Doe"})
  end

  test "update_author/1 with valid data updates the author" do
    assert {:ok, author} = Authors.create_author(%{"name" => "John Doe"})
    assert {:ok, updated_author} = Authors.update_author(author.id, %{"name" => "Jane Doe"})
    assert updated_author.name == "Jane Doe"
  end

  test "update_author/1 with duplicate name returns error :author_exists" do
    {:ok, author1} = Authors.create_author(%{"name" => "John Doe"})
    {:ok, _author2} = Authors.create_author(%{"name" => "Jane Doe"})
    assert {:error, :author_exists} = Authors.update_author(author1.id, %{"name" => "Jane Doe"})
    assert author1.name == "John Doe"
  end

  test "delete_author/1 deletes the author" do
    {:ok, author} = Authors.create_author(@valid_attrs)
    assert {:ok, %BooksApi.Authors.Author{}} = Authors.delete_author(author)
    assert Authors.get_author(author.id) == nil
  end

  test "update_author/2 with unique new name succeeds" do
    {:ok, author} = Authors.create_author(%{"name" => "John Doe"})
    assert {:ok, updated_author} = Authors.update_author(author.id, %{"name" => "Updated Name"})
    assert updated_author.name == "Updated Name"
  end

  test "change_author/1 returns a changeset for the author" do
    {:ok, author} = Authors.create_author(@valid_attrs)
    changeset = Authors.change_author(author)
    assert %Ecto.Changeset{} = changeset
    assert changeset.data.id == author.id
  end

  test "find_or_create_author/1 finds existing author by name" do
    {:ok, author} = Authors.create_author(%{"name" => "John Doe"})
    assert {:ok, found_author} = Authors.find_or_create_author(%{"name" => "John Doe"})
    assert found_author.name == author.name
  end

  test "find_or_create_author/1 creates new author if not found" do
    assert {:ok, new_author} = Authors.find_or_create_author(%{"name" => "New Author"})
    assert new_author.name == "New Author"
    assert Authors.get_author(new_author.id) == new_author
  end
end
