defmodule HermexWeb.ViewHelpers do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  def render_many_with_metadata(page, module, template) do
    metadata = Map.take(page, ~w(page_number page_size total_entries total_pages)a)
    Map.put(metadata, :data, Phoenix.View.render_many(page.entries, module, template))
  end
end
