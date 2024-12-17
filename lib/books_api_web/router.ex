defmodule BooksApiWeb.Router do
  use BooksApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BooksApiWeb do
    pipe_through :api
    get "/books", BooksController, :index
    post "/books", BooksController, :create
    get "/books/:id", BooksController, :show
    delete "/books/:id", BooksController, :delete
    put "/books/:id", BooksController, :update

    get "/authors", AuthorController, :index
    post "/authors", AuthorController, :create
    get "/authors/:id", AuthorController, :show
    delete "/authors/:id", AuthorController, :delete
    put "/authors/:id", AuthorController, :update

  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:books_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: BooksApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
