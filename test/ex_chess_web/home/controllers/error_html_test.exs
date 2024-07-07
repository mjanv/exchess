defmodule ExChessWeb.Home.Controllers.ErrorHTMLTest do
  use ExChessWeb.ConnCase, async: true

  import Phoenix.Template
  
  alias ExChessWeb.Home.Controllers.ErrorHTML

  test "renders 404.html" do
    assert render_to_string(ErrorHTML, "404", "html", []) == "Not Found"
  end

  test "renders 500.html" do
    assert render_to_string(ErrorHTML, "500", "html", []) == "Internal Server Error"
  end
end
