defmodule Hermex.ExAdmin.Device do
  use ExAdmin.Register

  register_resource Hermex.Device do
    index do
      selectable_column()

      column :id
      column :app
      column :inserted_at

      actions()
    end

    show _topic do
      attributes_table do
        row :id
        row :app
        row :token
        row :custom_data
        row :inserted_at
      end
    end

    form device do
      inputs do
        input device, :token
        input device, :app, collection: Hermex.Repo.all(Hermex.App)
      end
    end
  end
end
