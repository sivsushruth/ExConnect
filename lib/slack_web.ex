defmodule ExConnect.SlackWeb do
  @base_url "https://slack.com/api/users.admin.invite"
  import ExConnect.Util

  def send_invite(email) do
    url = @base_url <> "?token=" <> admin_token <> "&email=" <> email
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
end