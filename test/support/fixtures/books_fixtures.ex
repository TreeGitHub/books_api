defmodule BooksApi.BooksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `BooksApi.Books` context.
  """

  @doc """
  Generate a book.
  """
  def book_fixture(attrs \\ %{}) do
    {:ok, book} =
      attrs
      |> Enum.into(%{
        summary: "some summary",
        tagline: "some tagline",
        title: "some title"
      })
      |> BooksApi.Books.create_book()

    book
  end
end
