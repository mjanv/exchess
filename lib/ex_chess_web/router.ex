defmodule ExChessWeb.Router do
  use ExChessWeb, :router

  alias ExChessWeb.Live.Accounts.UserAuth
  import ExChessWeb.Live.Accounts.UserAuth

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

  scope "/", ExChessWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{ExChessWeb.Live.Accounts.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", Live.Accounts.UserRegistrationLive, :new)
      live("/users/log_in", Live.Accounts.UserLoginLive, :new)
      live("/users/reset_password", Live.Accounts.UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", Live.Accounts.UserResetPasswordLive, :edit)
    end

    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", ExChessWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{ExChessWeb.Live.Accounts.UserAuth, :ensure_authenticated}] do
      live("/home", Games.Live.HomeLive, :index)

      live("/users/settings", Live.Accounts.UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", Live.Accounts.UserSettingsLive, :confirm_email)
    end
  end

  scope "/games", ExChessWeb.Games do
    pipe_through(:browser)

    live_session :default, on_mount: [{UserAuth, :ensure_authenticated}] do
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

  scope "/", ExChessWeb do
    pipe_through([:browser])

    get("/", PageController, :home)
    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{ExChessWeb.Live.Accounts.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", Live.Accounts.UserConfirmationLive, :edit)
      live("/users/confirm", Live.Accounts.UserConfirmationInstructionsLive, :new)
    end
  end

  if Application.compile_env(:ex_chess, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ExChessWeb.Telemetry)
    end
  end
end
