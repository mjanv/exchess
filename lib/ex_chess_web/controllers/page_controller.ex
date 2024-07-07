defmodule ExChessWeb.PageController do
  use ExChessWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
