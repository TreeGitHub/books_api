defmodule BooksApiWeb.PublishersControllerTest do
  use BooksApiWeb.ConnCase

  alias BooksApi.Publishers

  @valid_attrs %{
    "name" => "Valid Publisher",
    "address" => "123 Valid St",
    "phone_number" => "123-456-7890",
    "website" => "http://validpublisher.com"
  }

  @invalid_attrs_missing_name %{
    "address" => "123 Missing Name St",
    "phone_number" => "123-456-7890",
    "website" => "http://missingname.com"
  }

  @invalid_attrs_invalid_website %{
    "name" => "Invalid Website Publisher",
    "address" => "123 Invalid St",
    "phone_number" => "123-456-7890",
    "website" => "invalid-website"
  }

  describe "POST /publishers" do

  end
end
