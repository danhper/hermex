defmodule BuildyPush.Controller.Utils do
  import Plug.Conn
  import Phoenix.Controller

  def handle_save(result, conn, opts \\ [])
  def handle_save({:ok, model}, conn, opts) do
    render_saved(conn, model, opts)
  end
  def handle_save({:error, changeset}, conn, _opts) do
    render_unprocessable(conn, changeset)
  end

  def render_saved(conn, model, opts \\ []) do
    conn
    |> put_status(get_status(opts))
    |> add_location(model, opts)
    |> render("show.json", [{model_key(model, opts), model}])
  end

  def render_unprocessable(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(BuildyPush.ChangesetView, "error.json", changeset: changeset)
  end

  defp get_status(opts) do
    cond do
      status = opts[:status] -> status
      opts[:location]        -> :created
      true                   -> :ok
    end
  end

  defp add_location(conn, model, opts) do
    if location = opts[:location] do
      put_resp_header(conn, "location", location.(model))
    else
      conn
    end
  end

  defp model_key(model, opts) do
    if key = opts[:key] do
      key
    else
      model.__struct__
      |> Atom.to_string
      |> String.split(".")
      |> List.last
      |> String.downcase
      |> String.to_atom
    end
  end
end
