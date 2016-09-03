defmodule ExConnect.CommonChild do
    def start_link({:slack, slack_token})do
      ExConnect.SlackRtm.start_link(slack_token)
    end

    def start_link({:irc, bot})do
      ExConnect.IrcBot.start_link(bot)
    end

    def start_link({:irc, bot}, opts)do
      ExConnect.IrcBot.start_link(bot, opts)
    end
end