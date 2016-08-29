defmodule ExBridge.Util do
  def slack_token do
    Application.get_env(:ex_bridge, :slack_token)
  end

  def irc_prefix do
    Application.get_env(:ex_bridge, :irc_prefix, "slack_")
  end 
end