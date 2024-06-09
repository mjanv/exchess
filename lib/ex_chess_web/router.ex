defmodule ExChessWeb.Router do
  use ExChessWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {ExChessWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ExChessWeb do
    pipe_through(:browser)

    get("/", PageController, :home)
    live("/home", Live.HomeLive)
    live("/board/:id", Live.BoardLive)
  end

  if Application.compile_env(:ex_chess, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ExChessWeb.Telemetry)
    end
  end
end
