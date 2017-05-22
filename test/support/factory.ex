defmodule Hermex.Factory do
  use ExMachina.Ecto, repo: Hermex.Repo

  def gcm_app_factory do
    %Hermex.App{
      platform: "gcm",
      name: sequence(:gcm_app, &("gcm-app-#{&1}")),
      settings: %{
        "auth_key" => sequence(:gcm_auth_key, &("gcm-auth-key-#{&1}"))
      }
    }
  end

  def apns_app_factory do
    %Hermex.App{
      platform: "apns",
      name: sequence(:apns_app, &("apns-app-#{&1}")),
      settings: %{
        "auth_key" => sequence(:apns_auth_key, &("apns-auth-key-#{&1}"))
      }
    }
  end

  def topic_factory do
    %Hermex.Topic{
      name: sequence(:topic_name, &("topic-name-#{&1}"))
    }
  end

  def device_factory do
    %Hermex.Device{
      app_id: insert(:gcm_app).id,
      token: sequence(:device_token, &("device-token-#{&1}"))
    }
  end

  def subscription_factory do
    %Hermex.Subscription{
      topic_id: insert(:topic).id,
      device_id: insert(:device).id
    }
  end

  def message_factory do
    %Hermex.Message{
      topic_id: insert(:topic).id,
      data: %{body: "foobar"}
    }
  end
end
