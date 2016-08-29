defmodule ExBridge.SlackRtm do
  use Slack
  alias Slack.Sends
  
  def send_message_as_user(user, message) do
    IO.inspect rtm = :gproc.lookup_pid({:n, :l, {__MODULE__}}) 
    IO.inspect send rtm, {:outgoing, "*" <> user <> "*: " <> message, "#general"}
  end

  def handle_info({:outgoing, text, channel}, slack) do
    IO.puts "Outgoing #{text} to #{channel}"
    send_message(text, channel, slack)
    {:ok}
  end

  def handle_info({:message, text, channel}, slack) do
    IO.puts "Got message #{text} from #{channel}"
    # send_message(text, channel, slack)
    {:ok}
  end

  def handle_info(_, _) do
    :ok
  end

  def handle_connect(slack) do
    :gproc.reg({:n, :l, {__MODULE__}})
    IO.puts "Connected as #{slack.me.name}"
  end
  

  def handle_message(message = %{type: "message"}, slack) do
    IO.inspect :gproc.lookup_pid({:n, :l, {ExBridge}})
    IO.inspect message
    
    ExBridge.IrcBot.send_message(message[:user], message[:text])
    :ok
  end

  def handle_message(_, _) do
    :ok
  end
end