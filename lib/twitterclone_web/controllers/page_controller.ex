defmodule TwittercloneWeb.PageController do
  use TwittercloneWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
  def start(conn, _params) do
    render conn, "start.html"
  end
end
