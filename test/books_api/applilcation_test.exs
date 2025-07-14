defmodule BooksApi.ApplicationTest do
  use ExUnit.Case, async: true

  test "config_change/3 calls Endpoint.config_change/3" do
    assert :ok = BooksApi.Application.config_change([], [], [])
  end
end
