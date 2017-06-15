defmodule Hermex.ExAdmin.Topic do
  use ExAdmin.Register

  register_resource Hermex.Topic do
    show topic do
      attributes_table do
        row :name
      end

      panel "Messages" do
        table_for topic.messages do
          column :data
          column :recipients_count
          column :sent_at
        end
      end

      panel "Subscriptions" do
        table_for topic.subscriptions do
          column :device
        end
      end
    end
  end
end
