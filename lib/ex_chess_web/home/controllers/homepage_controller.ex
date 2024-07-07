defmodule ExChessWeb.Home.Controllers.HomepageController do
  use ExChessWeb, :controller

  def home(conn, _params) do
    render(conn, :homepage, layout: false)
  end
end
