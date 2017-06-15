defmodule Hermex.ExAdmin.Dashboard do
  use ExAdmin.Register

  require Ecto.Query
  import Ecto.Query

  register_page "Dashboard" do
    menu priority: 1, label: "Dashboard"
    content do
      columns do
        column do
          panel "Recent Messages" do
            order_by(Hermex.Message, desc: :id)
            |> limit(5)
            |> Hermex.Repo.all
            |> table_for do
              column "data", fn(m) -> a m.data, href: "/admin/messages/#{m.id}" end
              column "recipients_count", &(text &1.recipients_count)
              column "sent_at", &(text &1.sent_at)
            end
          end
        end

        column do
          panel "Recent Devices" do
            order_by(Hermex.Device, desc: :id)
            |> limit(5)
            |> Hermex.Repo.all
            |> Hermex.Repo.preload(:app)
            |> table_for do
              column "app", &(text &1.app.name)
              column "platform", &(text &1.app.platform)
              column "token", fn(d) ->
                a d.token, href: "/admin/devices/#{d.id}"
              end
            end
          end
        end
      end
    end
  end
end
