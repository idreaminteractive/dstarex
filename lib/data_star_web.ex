defmodule DstarEx.Web do
  defp get_csrf_token(opts \\ []) do
    csrf = Keyword.get(opts, :csrf)

    opts =
      if csrf do
        Keyword.put(opts, :"x-csrf-token", csrf)
      else
        opts
      end

    # remove it
    Keyword.delete(opts, :csrf)
  end

  def dspost(path, opts \\ []) do
    opts = get_csrf_token(opts)
    formatted_opts = format_options(opts)
    "@post('#{path}'#{formatted_opts})"
  end

  def dsget(path, opts \\ []) do
    formatted_opts = format_options(opts)
    "@get('#{path}'#{formatted_opts})"
  end

  def dsput(path, opts \\ []) do
    opts = get_csrf_token(opts)
    formatted_opts = format_options(opts)
    "@put('#{path}'#{formatted_opts})"
  end

  def dsdelete(path, opts \\ []) do
    opts = get_csrf_token(opts)
    formatted_opts = format_options(opts)
    "@delete('#{path}'#{formatted_opts})"
  end

  def dspatch(path, opts \\ []) do
    opts = get_csrf_token(opts)
    formatted_opts = format_options(opts)
    "@patch('#{path}'#{formatted_opts})"
  end

  defp format_options([]), do: ""

  defp format_options(opts) do
    formatted_pairs =
      opts
      |> Enum.map(&format_option_pair/1)
      |> Enum.join(", ")

    ", { #{formatted_pairs} }"
  end

  defp format_option_pair({key, value}) when is_atom(key) do
    "#{key}: #{format_value(value)}"
  end

  defp format_value(value) when is_binary(value) do
    "'#{value}'"
  end

  defp format_value(value) when is_list(value) do
    # Handle keyword lists
    if Keyword.keyword?(value) do
      formatted_pairs =
        value
        |> Enum.map(fn {k, v} -> "#{k}: #{format_value(v)}" end)
        |> Enum.join(", ")

      "{ #{formatted_pairs} }"
    else
      # Handle regular lists as arrays
      formatted_items =
        value
        |> Enum.map(&format_value/1)
        |> Enum.join(", ")

      "[#{formatted_items}]"
    end
  end

  defp format_value(value) when is_atom(value) do
    "#{value}"
  end

  defp format_value(value) when is_number(value) do
    "#{value}"
  end
end
