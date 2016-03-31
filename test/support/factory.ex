defmodule BuildyPush.Factory do
  use ExMachina.Ecto, repo: BuildyPush.Repo

  def gcm_app_factory do
    %BuildyPush.App{
      platform: "gcm",
      name: sequence(:gcm_app, &("gcm-app-#{&1}")),
      settings: %{
        "auth_key" => sequence(:gcm_auth_key, &("gcm-auth-key-#{&1}"))
      }
    }
  end

  def topic_factory do
    %BuildyPush.Topic{
      name: sequence(:topic_name, &("topic-name-#{&1}"))
    }
  end
end
