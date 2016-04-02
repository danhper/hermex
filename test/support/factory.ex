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

  def device_factory do
    %BuildyPush.Device{
      app_id: insert(:gcm_app).id,
      token: sequence(:device_token, &("device-token-#{&1}"))
    }
  end

  def subscription_factory do
    %BuildyPush.Subscription{
      topic_id: insert(:topic).id
    }
  end

  def message_factory do
    %BuildyPush.Message{
      topic_id: insert(:topic).id,
      data: %{body: "foobar"}
    }
  end
end
