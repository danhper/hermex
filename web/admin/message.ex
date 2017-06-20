defmodule Hermex.ExAdmin.Message do
  use ExAdmin.Register

  register_resource Hermex.Message do
    index do
      selectable_column()

      column :id
      column :topic
      column :sent_at
      column :scheduled_at

      actions()
    end

    show _message do
      attributes_table do
        row :id
        row :topic
        row :sender_key
        row :sent_at
        row :scheduled_at
        row :message_data, &(Phoenix.HTML.Tag.content_tag(:pre, Poison.encode!(&1.data, pretty: true)))
        row :message_options, &(Phoenix.HTML.Tag.content_tag(:pre, Poison.encode!(&1.options, pretty: true)))
      end
    end

    controller do
      before_filter :decode, only: [:update, :create]
      def decode(conn, params) do
        params = params
        |> update_in([:message, :data], &(Poison.decode!(&1 || "")))
        |> update_in([:message, :options], &(Poison.decode!(&1 || "")))
        {conn, params}
      end

      after_filter :send_message, only: [:create]
      def send_message(conn, _params, message, :create) do
        Hermex.MessageProcessor.Dispatcher.process_message(message)
        conn
      end
    end

    form message do
      inputs do
        content do
          content_tag(:div, class: "hidden-inputs") do
            [Phoenix.HTML.Tag.tag(:input, id: "input_message_data", name: "message[data]", type: "hidden"),
             Phoenix.HTML.Tag.tag(:input, id: "input_message_options", name: "message[options]", type: "hidden")]
          end
        end
        content do
          content_tag(:div, class: "form-group") do
            [content_tag(:label, "Data", class: "col-sm-2 control-label"),
            content_tag(:div, class: "col-sm-10") do
              content_tag(:div, "", id: "message_data")
            end]
          end
        end
        content do
          content_tag(:div, class: "form-group") do
            [content_tag(:label, "Options", class: "col-sm-2 control-label"),
            content_tag(:div, class: "col-sm-10") do
              content_tag(:div, "", id: "message_options")
            end]
          end
        end
        input message, :sender_key
        input message, :scheduled_at
        input message, :topic, collection: Hermex.Repo.all(Hermex.Topic)

        content do
          content_tag(:div) do
            [
              Phoenix.HTML.Tag.tag(:link, rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/jsoneditor/5.7.0/jsoneditor.min.css"),
              Phoenix.HTML.Tag.tag(:link, rel: "stylesheet", href: "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/css/bootstrap-datetimepicker.min.css"),
              content_tag(:script, "", src: "https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.18.1/moment.min.js"),
              content_tag(:script, "", src: "https://cdnjs.cloudflare.com/ajax/libs/moment-timezone/0.5.13/moment-timezone-with-data.min.js"),
              content_tag(:script, "", src: "https://cdnjs.cloudflare.com/ajax/libs/jsoneditor/5.7.0/jsoneditor.min.js"),
              content_tag(:script, "", src: "https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datetimepicker/4.17.47/js/bootstrap-datetimepicker.min.js")
            ]
          end
        end
      end

      javascript do
        """
        function initJSON(elemSelector, initialData) {
          var messageTextarea = document.querySelector(elemSelector);
          var options = {
            mode: "code",
            indentation: 2
          };
          var editor = new JSONEditor(messageTextarea, options);
          editor.set(initialData);
          return editor;
        }

        $(function() {
          var dataEditor = initJSON('#message_data', #{Poison.encode!(message.data || %{})});
          var optionsEditor = initJSON('#message_options', #{Poison.encode!(message.options || %{})});
          $('#message_scheduled_at').datetimepicker({
            format: "YYYY-MM-DD HH:mm:ssZ"
          });

          $('#new_message').on('submit', function (e) {
            try {
              $('#input_message_data').val(JSON.stringify(dataEditor.get()));
              $('#input_message_options').val(JSON.stringify(optionsEditor.get()));
            } catch (ex) {
              console.log(ex);
              e.preventDefault();
            }
          });
        });
        """
      end
    end
  end
end
