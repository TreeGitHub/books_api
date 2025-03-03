defmodule BooksApiWeb.Router do
  use BooksApiWeb, :router

  # Enable CORS for your React app running on localhost:3000
  pipeline :api do
    # Add CORSPlug directly here
    plug(CORSPlug, origin: "http://localhost:3000")
    plug(:accepts, ["json"])
  end

  scope "/api", BooksApiWeb do
    pipe_through(:api)
    resources("/books", BooksController, only: [:index, :show, :create, :update, :delete])
    resources("/authors", AuthorsController, only: [:index, :show, :create, :delete, :update])

    resources("/books_authors", BooksAuthorsController,
      only: [:index, :show, :create, :delete, :update]
    )
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:books_api, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: BooksApiWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
