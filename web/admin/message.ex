defmodule Hermex.ExAdmin.Message do
  use ExAdmin.Register

  register_resource Hermex.Message do
    form message do
      inputs do
        input message, :data, type: :text
      end
    end
  end
end
