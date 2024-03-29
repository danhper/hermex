defmodule HermexWeb.ErrorView do
  use HermexWeb, :view

  def render("400.json", %{reason: reason}) do
    %{errors: Exception.message(reason)}
  end

  def render("401.json", _assigns) do
    %{error: "not authorized"}
  end

  def render("404.json", _assigns) do
    %{error: "not found"}
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
