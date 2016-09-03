defmodule ExConnect.Config do
  defstruct server:  nil,
            port:    nil,
            pass:    nil,
            nick:    nil,
            user:    nil,
            name:    nil,
            channel: nil,
            client:  nil,
            send_only: nil,
            slack_id: nil

  def from_params(params) when is_map(params) do
    Enum.reduce(params, %ExConnect.Config{}, fn {k, v}, acc ->
      case Map.has_key?(acc, k) do
        true  -> Map.put(acc, k, v)
        false -> acc
      end
    end)
  end
end
