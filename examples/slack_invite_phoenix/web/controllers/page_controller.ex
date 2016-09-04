defmodule ExConnectApp.PageController do
  use ExConnectApp.Web, :controller

  alias Phoenix.Controller.Flash

  def index(conn, _params) do
    render conn, "slack_invite.html"
  end

  def slack_invite(conn, params) do
    conn2  = case params["user"] do
                %{"email" => email} ->
                  IO.inspect "===> Email"
                  IO.inspect email
                  ExConnect.SlackRtm.send_slack_invite({:email, email})
                  put_flash(conn, :notice, "Sent slack invite to #{email}")
                _ ->
                  put_flash(conn, :error, "Invalid request!")
              end
    IO.inspect params
    redirect conn, to: "/post_slack_invite"
  end

  def post_slack_invite(conn, params) do
    IO.inspect params
    render conn, "post_slack_invite.html", email: "sivsushruth@gmail.com"
  end
end
