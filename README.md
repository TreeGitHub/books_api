📘 Books API
🎯 Purpose

This is the backend of the Chapters book tracking app. It provides a RESTful API for managing:

    Users and authentication

    Books and authors

    User-specific reading lists

🧰 Technologies Used

    Elixir – functional programming language

    Phoenix – web framework for building APIs

    Ecto – database layer and validations

    PostgreSQL – database (default in Phoenix apps)

🧠 Responsibilities

    Exposes API endpoints for CRUD operations on:

        Books (/api/books)

        Authors (/api/authors)

        Users (/api/users)

    Handles user registration and login

    Manages reading list logic (/api/users/:id/reading_list)

    Enforces validation and business rules through schemas and changesets

    Returns JSON responses for use by the React frontend (chapters_ui)

🚀 Getting Started

To start the Phoenix server:

mix setup # Installs dependencies and sets up the DB
mix phx.server # Starts the server

# or for IEx:

iex -S mix phx.server

Then visit http://localhost:4000 in your browser.
