defmodule BooksApiWeb.ErrorJSON do
  def render("404.json", %{resource: resource}) do
    %{errors: %{detail: "#{resource} not found"}}
  end

  def render("409.json", %{resource: resource}) do
    %{errors: %{detail: resource}}
  end

  def render("422.json", %{changeset: changeset}) do
    # You can return the changeset errors here
    errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
    %{errors: errors}
  end

  # Catch-all for other cases
  def render(_template, _assigns) do
    %{errors: %{detail: "An unknown error occurred"}}
  end

  defmodule BooksApiWeb.ErrorJSON do
    def render("422.json", %{errors: errors}) do
      %{errors: format_errors(errors)}
    end

    defp format_errors(errors) when is_list(errors) do
      Enum.into(errors, %{}, fn {field, {message, _opts}} -> {field, message} end)
    end

    defp format_errors(errors), do: errors
  end
end
