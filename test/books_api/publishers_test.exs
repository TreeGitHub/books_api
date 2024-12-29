defmodule BooksApi.PublishersTest do
  use BooksApi.DataCase, async: true

  alias BooksApi.Publishers
  alias BooksApi.Publishers.Publisher

  describe "create_publisher/1" do
    test "successfully creates a publisher with valid attributes" do
      valid_attrs = %{
        "name" => "Awesome Publishing House",
        "address" => "123 Book St, Storyville",
        "phone_number" => "123-456-7890",
        "website" => "http://awesome-publishing.com"
      }

      assert {:ok, %Publisher{} = publisher} = Publishers.create_publisher(valid_attrs)
      assert publisher.name == "Awesome Publishing House"
      assert publisher.address == "123 Book St, Storyville"
      assert publisher.phone_number == "123-456-7890"
      assert publisher.website == "http://awesome-publishing.com"
    end

    test "returns an error if the publisher name already exists" do
      existing_attrs = %{
        "name" => "Duplicate Publishing",
        "address" => "456 Novel Ave",
        "phone_number" => "987-654-3210",
        "website" => "http://duplicate-publishing.com"
      }

      # Insert the initial publisher
      assert {:ok, _publisher} = Publishers.create_publisher(existing_attrs)

      # Attempt to insert a publisher with the same name
      assert {:error, :publisher_exists} = Publishers.create_publisher(existing_attrs)
    end

    test "returns an error if required attributes are missing" do
      invalid_attrs = %{"name" => nil}

      assert {:error, changeset} = Publishers.create_publisher(invalid_attrs)
      assert changeset.errors[:name] == {"can't be blank", [validation: :required]}
    end

    test "returns an error if the website is invalid" do
      invalid_attrs = %{
        "name" => "Invalid Website Publishing",
        "address" => "789 Short Story Rd",
        "phone_number" => "555-555-5555",
        "website" => "invalid-website"
      }

      assert {:error, changeset} = Publishers.create_publisher(invalid_attrs)
      assert changeset.errors[:website] == {"has invalid format", [validation: :format]}
    end
  end
end
