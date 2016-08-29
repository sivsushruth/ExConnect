defmodule ExBridge do
  use Application
  import ExBridge.Util

  def start(_type, _args) do
    # :observer.start()
    import Supervisor.Spec, warn: true
    :gproc.reg({:n, :l, {__MODULE__}})
    irc_slack_users = Slack.Web.Users.list(%{token: slack_token})
    |> Map.get("members")
    |> Enum.filter(fn(member) -> member["real_name"] != nil end)
    |> Enum.map(fn(member) ->
      %{
          :server => "chat.freenode.net", 
          :port => 8000,
          :nick => irc_prefix <> member["name"], 
          :user => irc_prefix <> member["real_name"], 
          :name => irc_prefix <> member["name"],
          :channel => "#bridge_test",
          :slack_id => member["id"]
        }
    end)
    |> Enum.reverse

    slack_bot = %{
                    :server => "chat.freenode.net", 
                    :port => 8000,
                    :nick => irc_prefix <> "bot", 
                    :user => irc_prefix <> "bot", 
                    :name => irc_prefix <> "bot",
                    :channel => "#bridge_test",
                    :slack_id => "slack_bot"
                  }

    irc_workers = irc_slack_users
                  |> Enum.map(fn bot -> worker(ExBridge.IrcBot, [bot, %{:send_only => true}], id: bot[:nick]) end)
    children = [
                  worker(ExBridge.SlackRtm, [slack_token], id: "slack_rtm"),
                  worker(ExBridge.IrcBot, [slack_bot], id: "slack_bot")      
               ] ++ irc_workers

    opts = [strategy: :one_for_one, name: ExBridge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def add_irc_user(nick) do
  end

end
