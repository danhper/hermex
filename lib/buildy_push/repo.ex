defmodule Hermex.Repo do
  use Ecto.Repo, otp_app: :hermex
  use Scrivener, page_size: 20
end
