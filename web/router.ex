defmodule Hermex.Router do
  use Hermex.Web, :router
  use ExAdmin.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Hermex.Plug.AuthenticateUser
  end

  pipeline :admin_basic_auth do
    plug BasicAuth, use_config: {:hermex, :admin}
  end

  scope "/", Hermex do
    pipe_through :browser

    get "/ping", PingController, :ping
  end

  scope "/api", Hermex do
    pipe_through :api

    resources "/apps", AppController, except: [:new, :edit]

    get "/apps/:platform/:name", AppController, :find

    resources "/topics", TopicController, except: [:new, :edit, :update]
    get "/devices/find", DeviceController, :find
    resources "/devices", DeviceController, except: [:new, :edit]
    resources "/subscriptions", SubscriptionController, except: [:new, :edit, :update]
    resources "/messages", MessageController, except: [:new, :edit, :update, :delete]
  end

  if Application.get_env(:hermex, :admin)[:enable] do
    scope "/admin", ExAdmin do
      pipe_through :browser
      if Application.get_env(:hermex, :admin)[:protected] do
        pipe_through :admin_basic_auth
      end
      admin_routes()
    end
  end
end
