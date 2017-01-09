defmodule BuildyPush.Util.JWT do
  def make_token(data, secret \\ default_secret()) do
    data
    |> Joken.token
    |> Joken.with_signer(make_signer(secret))
    |> Joken.sign
    |> Joken.get_compact
  end

  def parse_token(raw_token, secret \\ default_secret()) do
    raw_token
    |> Joken.token
    |> Joken.with_validation("iss", &(is_binary(&1)))
    |> Joken.with_signer(make_signer(secret))
    |> Joken.verify
  end

  defp make_signer(secret) do
    Joken.hs256(secret)
  end

  defp default_secret() do
    Application.get_env(:buildy_push, :auth)[:secret]
  end
end
