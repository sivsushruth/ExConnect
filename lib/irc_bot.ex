defmodule ExConnect.IrcBot do
  use GenServer
  require Logger
  import ExConnect.Util
  alias ExConnect.Config, as: Config

  alias ExIrc.Client

  def start_link(params) do
    start_link(params, %{:send_only => false})
  end

  def start_link(%{:nick => nick, :slack_id => slack_id} = params, opts) when is_map(params) do
    config1 = Config.from_params(params)
    config2 = Map.merge(config1, Config.from_params(opts), fn _k, v1, v2 ->
      case v2 do
        nil -> v1
        _ -> v2
      end
    end)
    GenServer.start_link(__MODULE__, [config2], name: String.to_atom(slack_id))
  end

  def init([config]) do
    #:random.seed(:erlang.now())
    #delay = :random.uniform(8000)
    #:timer.sleep(delay)
    {:ok, client}  = ExIrc.start_client!()
    Client.add_handler client, self()
    Logger.debug "Connecting to server #{inspect config}"
    Client.connect! client, config.server, config.port
    {:ok, %Config{config | :client => client}}
  end

  def send_message(slack_id, message) do
    GenServer.cast(String.to_atom(slack_id), {:send, message})
  end

  def maybe_remove_bot(slack_id) do
    IO.inspect GenServer.whereis(String.to_atom(slack_id))
    GenServer.stop(String.to_atom(slack_id))
  end

  def handle_cast({:send, message}, config) do
    Client.msg config.client, :privmsg, config.channel, message
    {:noreply, config}
  end

  def handle_info({:connected, server, port}, config) do
    Logger.debug "Connected to #{server}:#{port}"
    Logger.debug "Logging to #{server}:#{port} as #{config.nick}.."
    Client.logon config.client, config.pass, config.nick, config.user, config.name
    {:noreply, config}
  end
  def handle_info(:logged_in, config) do
    Logger.debug "Logged in to #{config.server}:#{config.port}"
    Logger.debug "Joining #{config.channel}.."
    Client.join config.client, config.channel
    {:noreply, config}
  end
  def handle_info(:disconnected, config) do
    Logger.debug "Disconnected from #{config.server}:#{config.port}"
    {:stop, :normal, config}
  end
  def handle_info({:joined, channel}, config) do
    Logger.debug "Joined #{channel}"
    # Client.msg config.client, :privmsg, config.channel, "Hello world!"
    {:noreply, config}
  end
  def handle_info({:names_list, channel, names_list}, config) do
    names = String.split(names_list, " ", trim: true)
            |> Enum.map(fn name -> " #{name}\n" end)
    Logger.info "Users logged in to #{channel}:\n#{names}"
    {:noreply, config}
  end
  def handle_info({:received, msg, %ExIrc.SenderInfo{:nick => nick}, channel}, config) do
    %{:send_only => send_only} = config
    IO.inspect (nick)
    IO.inspect config
    case {send_only, String.starts_with?(nick, ExConnect.Util.irc_prefix)} do
      {true, _} -> :ok
      {_, false} ->
          Logger.info "#{nick} from #{channel}: #{msg}"
          ExConnect.SlackRtm.send_message_as_user(nick, msg)
      _ -> :ok
    end
    {:noreply, config}
  end
  def handle_info({:mentioned, msg, %ExIrc.SenderInfo{:nick => nick}, channel}, config) do
    Logger.warn "#{nick} mentioned you in #{channel}"
    case String.contains?(msg, "hi") do
      true ->
        reply = "Hi #{nick}!"
        Client.msg config.client, :privmsg, config.channel, reply
        Logger.info "Sent #{reply} to #{config.channel}"
      false ->
        :ok
    end
    {:noreply, config}
  end
  def handle_info({:received, msg, %ExIrc.SenderInfo{:nick => nick}}, config) do
    Logger.warn "#{nick}: #{msg}"
    reply = "Hi!"
    Client.msg config.client, :privmsg, nick, reply
    Logger.info "Sent #{reply} to #{nick}"
    {:noreply, config}
  end
  # Catch-all for messages you don't care about
  def handle_info(_msg, config) do
    {:noreply, config}
  end

  def terminate(_, state) do
    # Quit the channel and close the underlying client connection when the process is terminating
    Client.quit state.client, "Goodbye, cruel world."
    Client.stop! state.client
    :ok
  end
end