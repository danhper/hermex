defmodule Hermex.ExAdmin.App do
  use ExAdmin.Register

  import Phoenix.HTML.Format, only: [text_to_html: 1]

  register_resource Hermex.App do
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
        row :gcm_auth_key, &(raw text_to_html(Map.get(&1.settings, "auth_key", "")))
        row :inserted_at
      end
    end

    form app do
      inputs do
        input app, :name
        input app, :platform, collection: ~w(apns gcm)
        input app, "GCM_auth_key", type: :string, name: "app[settings][auth_key]", value: app.settings["auth_key"]
        input app, "APNS_certificate", type: :text, name: "app[settings][cert]", value: app.settings["cert"]
        input app, "APNS_key", type: :text, name: "app[settings][key]", value: app.settings["key"]
      end

      javascript do
        """
        $(document).ready(function() {
          var inputs = ['#app_GCM_auth_key_input', '#app_APNS_certificate_input', '#app_APNS_key_input'];
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
