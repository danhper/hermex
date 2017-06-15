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
        content do
          content_tag(:div, class: "form-group") do
            [content_tag(:label, "Data", class: "col-sm-2 control-label"),
            content_tag(:div, class: "col-sm-10") do
              content_tag(:div, "", id: "message_data")
            end]
          end
        end
        # input message, :raw_data, type: :text, name: "message[data]", label: "data", value: Poison.encode!(Map.get(message, :data) || %{}, pretty: true)
        input message, :raw_options, type: :text, name: "message[options]", label: "options", value: Poison.encode!(Map.get(message, :options), pretty: true)
        input message, :sender_key
        input message, :scheduled_at, type: Ecto.DateTime

        content do
          content_tag(:script, "", src: "https://cdnjs.cloudflare.com/ajax/libs/jsoneditor/5.7.0/jsoneditor.min.js")
        end
        content do
          Phoenix.HTML.Tag.tag(:link, rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/jsoneditor/5.7.0/jsoneditor.min.css")
        end
      end

      javascript do
        """
        $(function() {
          var messageTextarea = document.querySelector('#message_data');
          var options = {
            "mode": "text",
            "indentation": 2
          };
          var editor = new JSONEditor(messageTextarea, options);
          editor.set(#{Poison.encode!(message.data || %{})});
        })
        """
      end
    end
  end
end
