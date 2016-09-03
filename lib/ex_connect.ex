defmodule ExConnect do
  use Application
  import ExConnect.Util

  def start(_type, _args) do
    import Supervisor.Spec, warn: true
    :gproc.reg({:n, :l, {__MODULE__}})
    slack_bot = %{
                    :server => "chat.freenode.net",
                    :port => 8000,
                    :nick => irc_prefix <> "bot",
                    :user => irc_prefix <> "bot",
                    :name => irc_prefix <> "bot",
                    :channel => "#bridge_test",
                    :slack_id => "slack_bot"
                  }
    children = [
                  worker(ExConnect.CommonChild, [], [id: "common_child", restart: :transient])
               ]


    opts = [strategy: :simple_one_for_one, name: ExConnect.Supervisor]
    {:ok, sup_pid} = Supervisor.start_link(children, opts)
    :gproc.reg_other({:n, :l, {:supervisor}}, sup_pid)
    Supervisor.start_child(sup_pid, [{:slack, slack_token}])
    Supervisor.start_child(sup_pid, [{:irc, slack_bot}])
    irc_slack_users
    |> Enum.map(&(Supervisor.start_child(sup_pid, [{:irc, &1}, %{send_only: true}])))
    {:ok, sup_pid}
  end

  def irc_slack_users do
    Slack.Web.Users.list(%{token: slack_token, presence: 1})
    |> Map.get("members")
    |> Enum.filter(fn(member) -> member["real_name"] != nil and member["presence"] == "active" end)
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
  end
end
