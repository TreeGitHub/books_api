defmodule BooksApiWeb.ErrorJSON do
  @moduledoc """
  Handles JSON error responses.
  """

  # Handle validation errors for "422 Unprocessable Entity"
  def render("422.json", %{changeset: changeset}) do
    %{errors: translate_changeset_errors(changeset)}
  end

  # Custom message for "404 Not Found"
  def render("404.json", %{resource: resource}) do
    %{errors: %{detail: "#{resource} not found"}}
  end

  # Default behavior for other known status codes
  def render(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  # Helper function to translate changeset errors
  defp translate_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
