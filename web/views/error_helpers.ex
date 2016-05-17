defmodule BuildyPush.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(BuildyPush.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(BuildyPush.Gettext, "errors", msg, opts)
    end
  end

  def translate_error(msg) do
    Gettext.dgettext(BuildyPush.Gettext, "errors", msg)
  end
end
