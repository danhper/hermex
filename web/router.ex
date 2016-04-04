defmodule BuildyPush.Router do
  use BuildyPush.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug BuildyPush.Plug.AuthenticateUser
  end

  scope "/", BuildyPush do
    pipe_through :browser
  end

  scope "/api", BuildyPush do
    pipe_through :api

    resources "/apps", AppController, except: [:new, :edit]
    resources "/topics", TopicController, except: [:new, :edit, :update]
    resources "/devices", DeviceController, except: [:new, :edit]
    resources "/subscriptions", SubscriptionController, except: [:new, :edit, :update]
    resources "/messages", MessageController, except: [:new, :edit, :update, :delete]
  end
end
