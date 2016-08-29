defmodule ExBridge.SlackRtm do
  use Slack
  alias Slack.Sends
  
  def send_message_as_user(user, message) do
      rtm = :gproc.lookup_pid({:n, :l, {__MODULE__}}) 
      send rtm, {:message, "*" <> user <> "* :" <> message, "#bridge"}
  end

  def handle_info(_, _) do
    :ok
  end

  def handle_connect(slack) do
    :gproc.reg({:n, :l, {__MODULE__}})
    IO.puts "Connected as #{slack.me.name}"
  end
  

  def handle_message(message = %{type: "message"}, slack) do
    ExBridge.IrcBot.send_message(<<"slack_bot">>, message[:text])
    :ok
  end

  def handle_message(_, _) do
    :ok
  end

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Sending message - #{text}"
    send_message(text, channel, slack)
    :ok
  end
end