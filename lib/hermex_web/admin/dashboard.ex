defmodule HermexWeb.ExAdmin.Dashboard do
  use ExAdmin.Register

  require Ecto.Query
  import Ecto.Query
  import HermexWeb.Router.Helpers

  register_page "Dashboard" do
    menu priority: 1, label: "Dashboard"
    content do
      columns do
        column do
          panel "Recent Messages" do
            order_by(Hermex.Push.Message, desc: :id)
            |> limit(5)
            |> Hermex.Repo.all
            |> Hermex.Repo.preload(:topic)
            |> table_for do
              column "id", fn(m) -> a m.id, href: admin_resource_path(HermexWeb.Endpoint, :show, :messages, m.id) end
              column "topic", &(text &1.topic.name)
              column "recipients_count", &(text &1.recipients_count)
              column "sent_at", &(text &1.sent_at)
            end
          end
        end

        column do
          panel "Recent Devices" do
            order_by(Hermex.Push.Device, desc: :id)
            |> limit(5)
            |> Hermex.Repo.all
            |> Hermex.Repo.preload(:app)
            |> table_for do
              column "id", fn(d) -> a d.id, href: admin_resource_path(HermexWeb.Endpoint, :show, :devices, d.id) end
              column "app", &(text &1.app.name)
              column "platform", &(text &1.app.platform)
              column "token", &(text &1.token)
            end
          end
        end
      end
    end
  end
end
