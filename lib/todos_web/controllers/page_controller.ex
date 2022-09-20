defmodule TodosWeb.PageController do
  use TodosWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
