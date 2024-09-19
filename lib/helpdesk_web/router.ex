defmodule HelpdeskWeb.Router do
  use HelpdeskWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {HelpdeskWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug :load_from_bearer
  end

  scope "/", HelpdeskWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/users", PageController, :users

   live "/health",HealthLive
   live "/helpdesk", HelpdeskLive


    sign_in_route(register_path: "/register", reset_path: "/reset")
    #  overrides: [HelpdeskWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default])
    sign_out_route Auth_Controller
    auth_routes_for Helpdesk.Accounts.User, to: Auth_Controller
    reset_route(layout: {HelpdeskWeb, :live})
    # overrides: [HelpdeskWeb.AuthOverrides, AshAuthentication.Phoenix.Overrides.Default])
  end

  # scope "/", HelpdeskWeb do
  #   ash_authentication_live_session :authentication_required,
  #   on_mount: {HelpdeskWeb.LiveUserAuth, :live_user_required} do
  #     live "/protected_route", ProjectLive.Index, :index
  #   end

  #   ash_authentication_live_session :authentication_optional,
  #   on_mount: {HelpdeskWeb.LiveUserAuth, :live_user_optional} do
  #     live "/", ProjectLive.Index, :index

  #      sign_in_route(on_mount: [{HelpdeskWeb.LiveUserAuth, :live_no_user}])
  #   end
  # end

  scope "/api/json" do
    pipe_through(:api)

    forward "/swaggerui",
            OpenApiSpex.Plug.SwaggerUI,
            path: "/api/json/open_api",
            default_model_expand_depth: 4

    # forward "/redoc",
    #         Redoc.Plug.RedocUI,
    #         spec_url: "/api/json/open_api"

    forward "/", HelpdeskWeb.JsonApiRouter
  end

  # Other scopes may use custom stacks.
  # scope "/api", HelpdeskWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:helpdesk, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: HelpdeskWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
