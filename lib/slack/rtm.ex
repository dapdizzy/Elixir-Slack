defmodule JSX.DecodeError do
  defexception [:reason, :string]

  def message(%JSX.DecodeError{reason: reason, string: string}) do
    "JSX could not decode string for reason: `:#{reason}`, string given:\n#{string}"
  end
end

defmodule Slack.Rtm do
  @moduledoc false
  @url "https://slack.com/api/rtm.start?token="

  def start(token) do
    case HTTPoison.get(@url <> token, [], options) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case JSX.decode(body, [{:labels, :atom}]) do
          {:ok, json}       -> {:ok, json}
          {:error, reason}  -> {:error, %JSX.DecodeError{reason: reason, string: body}}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  defp option_keys(), do: [:timeout, :recv_timeout, :stream_to, :async, :proxy, :proxy_auth, :ssl, :follow_redirect, :max_redirest]

  defp options() do
    option_keys
    |> Enum.reduce([],
      fn option, options_list ->
        case Aplication.get_env(Slack.Rtm, option) do
          nil -> options_list
          value -> [{option, value}|options_list]
        end
      end)
  end
end
