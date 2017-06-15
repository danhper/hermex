defmodule Hermex.ExAdmin.Subscription do
  use ExAdmin.Register

  register_resource Hermex.Subscription do
    index do
      selectable_column()

      column :id
      column :topic
      column :device, &(text "#{&1.device.id} (#{&1.device.app.name})")
      column :inserted_at

      actions()
    end

    show _subscription do
      attributes_table do
        row :id
        row :topic
        row :device, &(text &1.device.id)
        row :device_app, &(text &1.device.app.name)
        row :inserted_at
      end
    end

    form subscription do
      inputs do
        input subscription, :topic, collection: Hermex.Repo.all(Hermex.Topic)
        input subscription, :device_id
      end
    end

    query do
      %{index: [preload: [:topic, device: :app]],
        show: [preload: [:topic, device: :app]]}
    end
  end
end
