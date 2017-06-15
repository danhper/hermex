defmodule Hermex.ExAdmin.App do
  use ExAdmin.Register

  register_resource Hermex.App do
    index do
      selectable_column()

      column :id
      column :name

      actions()
    end

    form app do
      inputs do
        input app, :name
        input app, :platform, collection: ~w(apns gcm)
        input app, :settings, schema: [auth_key: :string, cert: :string, key: :string]
      end
    end
  end
end
