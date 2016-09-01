defmodule ExConnect.Util do
  def slack_token do
    Application.get_env(:ex_connect, :slack_token)
  end

  def irc_prefix do
    Application.get_env(:ex_connect, :irc_prefix, "slack_")
  end

  def admin_token do
    Application.get_env(:ex_connect, :admin_token)
  end

end