defmodule Hermex.ExAdmin.Topic do
  use ExAdmin.Register

  import Hermex.Router.Helpers

  register_resource Hermex.Topic do
    index do
      selectable_column()

      column :id
      column :name

      actions()
    end

    show topic do
      attributes_table do
        row :name
      end

      panel "Messages" do
        table_for topic.messages do
          column :id, &(a &1.id, href: admin_resource_path(Hermex.Endpoint, :show, :messages, &1.id))
          column :topic
          column :recipients_count
          column :sent_at
        end
      end

      panel "Subscriptions" do
        table_for topic.subscriptions do
          column :device, &(text &1.id)
          column(:app, fn t ->
            app = t.device.app
            a app.name, href: admin_resource_path(Hermex.Endpoint, :show, :app, app.id)
          end)
        end
      end
    end

    query do
      %{show: [preload: [messages: :topic, subscriptions: [device: :app]]]}
    end
  end
end
