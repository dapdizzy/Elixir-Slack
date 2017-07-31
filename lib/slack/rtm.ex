defmodule Poison.DecodeError do
  defexception [:reason, :string]

  def message(%Poison.DecodeError{reason: reason, string: string}) do
    "Poison could not decode string for reason: `:#{reason}`, string given:\n#{string}"
  end
end

defmodule Slack.Rtm do
  @moduledoc false

  def start(token) do
<<<<<<< .mine
    case HTTPoison.get(@url <> token, [], options) do
      {:ok, %HTTPoison.Response{body: body}} ->
        case JSX.decode(body, [{:labels, :atom}]) do
          {:ok, json}       -> {:ok, json}
          {:error, reason}  -> {:error, %JSX.DecodeError{reason: reason, string: body}}
        end
      {:error, reason} -> {:error, reason}




=======
    slack_url(token)
    |> HTTPoison.get()
    |> handle_response()
  end

  defp handle_response({:ok, %HTTPoison.Response{body: body}}) do
    case Poison.Parser.parse(body, keys: :atoms) do
      {:ok, %{ok: true} = json} -> {:ok, json}
      {:ok, %{error: reason}} -> {:error, "Slack API returned an error `#{reason}.\n Response: #{body}"}
      {:error, reason} -> {:error, %Poison.DecodeError{reason: reason, string: body}}
      _ -> {:error, "Invalid RTM response"}
>>>>>>> .theirs
    end
  end
<<<<<<< .mine

  defp option_keys(), do: [:timeout, :recv_timeout, :stream_to, :async, :proxy, :proxy_auth, :ssl, :follow_redirect, :max_redirest]

  defp options() do
    option_keys
    |> Enum.reduce([],
      fn option, options_list ->
        case Application.get_env(:httpoison, option) do
          nil -> options_list
          value -> [{option, value}|options_list]
        end
      end)
  end
end
=======
  defp handle_response(error), do: error

  defp slack_url(token) do
    Application.get_env(:slack, :url, "https://slack.com") <> "/api/rtm.start?token=#{token}"
  end
end








>>>>>>> .theirs
