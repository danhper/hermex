defmodule BuildyPush.Plug.AuthenticateUser do
  @behaviour Plug

  import Plug.Conn

  alias BuildyPush.Util.JWT

  def init(opts) do
    opts
    |> Enum.into(%{})
    |> Map.put_new(:secret, Application.get_env(:buildy_push, :auth)[:secret])
  end

  def call(conn, opts) do
    case fetch_token(conn, opts) do
      {:ok, claims} ->
        handle_auth_success(conn, claims)
      :error ->
        render_unauthorized(conn)
    end
  end

  defp handle_auth_success(conn, claims) do
    {conn, metadata} = Enum.reduce claims, {conn, []}, fn {key, value}, {conn, metadata} ->
      key = String.to_atom(key)
      {assign(conn, key, value), Keyword.put(metadata, key, value)}
    end
    Logger.metadata(metadata)
    conn
  end

  defp fetch_token(conn, %{secret: secret}) do
    with [authorization] <- get_req_header(conn, "authorization"),
         [_matched, raw_token] <- Regex.run(~r{Bearer (.*)}, authorization),
         %Joken.Token{error: nil} = token  <- JWT.parse_token(raw_token, secret) do
           {:ok, token.claims}
      end |> case do
               {:ok, _claims} = result -> result
               _                       -> :error
      end
  end

  defp render_unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(BuildyPush.ErrorView, "401.json")
    |> halt
  end
end
