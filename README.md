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

🛠️ Environment Setup

To run this project locally, make sure you have the following installed:

📦 Prerequisites
Tool Version (Recommended)
Elixir 1.15+
Erlang/OTP 25+
Phoenix 1.7+
PostgreSQL 13+
Node.js 18+ (for asset bundling)
npm Comes with Node

📎 Tip: If you’re using asdf for version management, your .tool-versions file might look like:

    elixir 1.15.0-otp-25
    erlang 25.3
    nodejs 18.17.0

🧪 Setup Steps

1. Install dependencies and setup DB
   mix setup

2. Start the Phoenix server
   mix phx.server
   or for interactive debugging:
   iex -S mix phx.server

3. Visit http://localhost:4000 in your browser.
