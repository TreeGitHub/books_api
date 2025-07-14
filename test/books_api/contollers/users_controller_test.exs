defmodule BooksApi.Controllers.UsersControllerTest do
  use BooksApiWeb.ConnCase, async: true
  alias BooksApi.Users

  @valid_user_attrs %{
    "username" => "Tim",
    "name" => "Tim",
    "email" => "tim@gmail.com",
    "password_hash" => "password123"
  }

  setup do
    {:ok, user} = Users.create_user(@valid_user_attrs)
    {:ok, user: user}
  end

  test "GET /users?username=Tim&password=password123 returns user details", %{
    conn: conn,
    user: user
  } do
    conn =
      get(conn, ~p"/api/users", %{
        "username" => user.username,
        "password" => user.password_hash
      })

    json = json_response(conn, 200)
    assert json["name"] == user.name
    assert json["message"] == "Login successful"
    assert json["user_id"] == user.id
    assert json["token"] == "dummy-token"
  end

  test "GET /users with invalid credentials returns error", %{conn: conn} do
    conn =
      get(conn, ~p"/api/users", %{
        "username" => "InvalidUser",
        "password" => "wrongpassword"
      })

    assert response(conn, 401)
    json = json_response(conn, 401)
    assert json["error"] == "Invalid credentials"
  end

  test "POST /users creates a new user", %{conn: conn} do
    new_user_attrs = %{
      "username" => "NewUser",
      "name" => "New User",
      "email" => "newuser@example.com",
      "password" => "password123"
    }

    conn =
      post(conn, ~p"/api/users", new_user_attrs)

    assert response(conn, 201)
    json = json_response(conn, 201)
    assert json["name"] == new_user_attrs["name"]
  end

  test "POST /users with existing username returns error", %{conn: conn, user: user} do
    existing_user_attrs = %{
      "username" => user.username,
      "name" => "Another User",
      "email" => "anotheruser@example.com",
      "password" => "password123"
    }

    conn =
      post(conn, ~p"/api/users", existing_user_attrs)

    assert response(conn, 409)
    json = json_response(conn, 409)
    assert json["errors"]["detail"] == "User with the same username already exists"
  end

  test "POST /users with invalid data returns error", %{conn: conn} do
    invalid_user_attrs = %{
      "username" => "",
      "name" => "Another User",
      "email" => "anotheruser@example.com",
      "password" => "password123"
    }

    conn =
      post(conn, ~p"/api/users", invalid_user_attrs)

    assert response(conn, 422)
    json = json_response(conn, 422)
    assert json["errors"]["detail"] == "An unknown error occurred"
  end
end
