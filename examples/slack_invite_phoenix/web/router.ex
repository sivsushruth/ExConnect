defmodule ExConnectApp.Router do
  use ExConnectApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExConnectApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/new", PageController, :slack_invite
    get "/post_slack_invite", PageController, :post_slack_invite
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExConnectApp do
  #   pipe_through :api
  # end
end
