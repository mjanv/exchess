defmodule ExChessWeb.Router do
  use ExChessWeb, :router

  alias ExChessWeb.Accounts.Live.UserAuth
  import ExChessWeb.Accounts.Live.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {ExChessWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", ExChessWeb.Home do
    pipe_through(:browser)

    get("/", Controllers.HomepageController, :home)
  end

  scope "/", ExChessWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :homepages, on_mount: [{UserAuth, :ensure_authenticated}] do
      live("/home", Games.Live.HomeLive, :index)
    end
  end

  scope "/users", ExChessWeb.Accounts do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{UserAuth, :redirect_if_user_is_authenticated}] do
      live("/register", Live.UserRegistrationLive, :new)
      live("/log_in", Live.UserLoginLive, :new)
      live("/reset_password", Live.UserForgotPasswordLive, :new)
      live("/reset_password/:token", Live.UserResetPasswordLive, :edit)
    end

    post("/log_in", Controllers.UserSessionController, :create)
  end

  scope "/users", ExChessWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{UserAuth, :ensure_authenticated}] do
      live("/settings", Accounts.Live.UserSettingsLive, :edit)
      live("/settings/confirm_email/:token", Accounts.Live.UserSettingsLive, :confirm_email)
    end
  end

  scope "/users", ExChessWeb.Accounts do
    pipe_through([:browser])

    live_session :current_user, on_mount: [{UserAuth, :mount_current_user}] do
      live("/confirm/:token", Live.UserConfirmationLive, :edit)
      live("/confirm", Live.UserConfirmationInstructionsLive, :new)
    end

    delete("/log_out", Controllers.UserSessionController, :delete)
  end

  scope "/games", ExChessWeb.Games do
    pipe_through(:browser)

    live_session :games, on_mount: [{UserAuth, :ensure_authenticated}] do
      live("/new", Live.HomeLive, :new)
      live("/:id", Live.GameLive)
    end
  end

  scope "/archives", ExChessWeb.Archives do
    pipe_through(:browser)

    live_session :archives, on_mount: [{UserAuth, :ensure_authenticated}] do
      live("/games", Live.GamesLive, :index)
      live("/upload", Live.UploadLive, :new)
    end
  end

  scope "/demos", ExChessWeb.Demos do
    pipe_through(:browser)

    get("/tiles", DemoController, :tiles)
    get("/pieces", DemoController, :pieces)
    get("/chessboard", DemoController, :chessboard)
  end

  if Application.compile_env(:ex_chess, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ExChessWeb.Telemetry)
    end
  end
end
