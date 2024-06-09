defmodule ExChessWeb.Router do
  use ExChessWeb, :router

  import ExChessWeb.UserAuth

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
      on_mount: [{ExChessWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", Accounts.UserRegistrationLive, :new)
      live("/users/log_in", Accounts.UserLoginLive, :new)
      live("/users/reset_password", Accounts.UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", Accounts.UserResetPasswordLive, :edit)
    end

    get("/", PageController, :home)
    post("/users/log_in", UserSessionController, :create)
  end

  scope "/", ExChessWeb do
    pipe_through([:browser, :require_authenticated_user])

    live_session :require_authenticated_user,
      on_mount: [{ExChessWeb.UserAuth, :ensure_authenticated}] do
      live("/home", Live.Games.HomeLive)
      live("/game/:id", Live.Games.GameLive)

      live("/users/settings", Accounts.UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", Accounts.UserSettingsLive, :confirm_email)
    end
  end

  scope "/", ExChessWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)

    live_session :current_user,
      on_mount: [{ExChessWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
    end
  end

  # Development routes

  if Application.compile_env(:ex_chess, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: ExChessWeb.Telemetry)
    end
  end
end
