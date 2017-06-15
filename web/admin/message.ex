defmodule Hermex.ExAdmin.Message do
  use ExAdmin.Register

  register_resource Hermex.Message do
    index do
      selectable_column()

      column :id
      column :topic
      column :sent_at

      actions()
    end

    form message do
      inputs do
        input message, :data, type: :text
      end
    end
  end
end
