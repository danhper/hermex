defmodule Hermex.ExAdmin.Device do
  use ExAdmin.Register

  register_resource Hermex.Device do
    index do
      selectable_column()

      column :id
      column :token
      column :app

      actions()
    end

    form device do
      inputs do
        input device, :token
        input device, :app, collection: Hermex.Repo.all(Hermex.App)
      end
    end
  end
end
