defmodule HermexWeb.ExAdmin.App do
  use ExAdmin.Register

  import Phoenix.HTML.Format, only: [text_to_html: 1]

  register_resource Hermex.Push.App do
    index do
      selectable_column()

      column :id
      column :name
      column :platform
      column :inserted_at

      actions()
    end

    show _app do
      attributes_table do
        row :id
        row :platform
        row :name
        row :apns_certificate, &(raw text_to_html(Map.get(&1.settings, "cert") || ""))
        row :apns_key, &(raw text_to_html(Map.get(&1.settings, "key") || ""))
        row :apns_env, &(raw text_to_html(Map.get(&1.settings, "env") || ""))
        row :gcm_auth_key, &(raw text_to_html(Map.get(&1.settings, "auth_key") || ""))
        row :inserted_at
      end
    end

    defmacro make_textarea(app, conn, name) do
      quote bind_quoted: [app: app, conn: conn, name: name] do
        content do
          wrap_item(app, name, "app", "APNS #{name}", nil, %{}, conn.params, false, fn(ext_name) ->
            build_control(:text, %{name => Map.get(app.settings || %{}, Atom.to_string(name), "")}, %{name: "app[settings][#{name}]"}, "", name, ext_name)
          end) |> elem(0)
        end
      end
    end

    form app do
      inputs do
        input app, :name
        input app, :platform, collection: ~w(apns gcm)
        input app, :GCM_auth_key, type: :string, name: "app[settings][auth_key]", value: app.settings["auth_key"]
        _ = make_textarea(app, conn, :cert)
        _ = make_textarea(app, conn, :key)
        input app, :APNS_env, name: "app[settings][env]", value: Map.get(app.settings || %{}, "env", "dev")
      end

      javascript do
        """
        $(document).ready(function() {
          var inputs = ['#app_GCM_auth_key_input', '#app_cert_input', '#app_key_input', '#app_APNS_env_input'];
          var updateInputs = function (currentPlatform) {
            $.each(inputs, function (i, selector) {
              if (!currentPlatform || (currentPlatform === 'gcm' && i !== 0) || (currentPlatform === 'apns' && i === 0)) {
                $(selector).hide();
              } else {
                $(selector).show();
              }
            });
          };
          var platformInput = $('#app_platform_id');
          $('#app_platform_id').change(function() {
            updateInputs(this.value);
          });
          updateInputs(platformInput.val());
        });
        """
      end
    end
  end
end
