defmodule BuildyPush.Repo do
  use Ecto.Repo, otp_app: :buildy_push
  use Scrivener, page_size: 20
end
