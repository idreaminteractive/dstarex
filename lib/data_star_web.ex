defmodule DstarEx.Web do
  def dspost(path, opts \\ []) do
    run("post", path, opts)
  end

  def dsget(path, opts \\ []) do
    run("get", path, opts)
  end

  def dsput(path, opts \\ []) do
    run("put", path, opts)
  end

  def dsdelete(path, opts \\ []) do
    run("delete", path, opts)
  end

  def dspatch(path, opts \\ []) do
    run("patch", path, opts)
  end

  defp get_csrf_token(opts) do
    csrf = Keyword.get(opts, :csrf)

    opts =
      if csrf do
        # we need to add this as a header
        # do we have a header already?`
        headers =
          opts
          |> Keyword.get(:headers, [])
          |> Keyword.put(:"x-csrf-token", csrf)

        Keyword.put(opts, :headers, headers)
      else
        opts
      end

    # remove it
    Keyword.delete(opts, :csrf)
  end

  defp run(method, path, opts) do
    opts = get_csrf_token(opts)

    formatted_opts = format_options(opts)
    "@#{method}('#{path}'#{formatted_opts})"
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
    "'#{key}': #{format_value(value)}"
  end

  defp format_value(value) when is_binary(value) do
    "'#{value}'"
  end

  defp format_value(value) when is_list(value) do
    # Handle keyword lists
    if Keyword.keyword?(value) do
      formatted_pairs =
        value
        |> Enum.map(fn {k, v} -> "'#{k}': #{format_value(v)}" end)
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

  def ds_bind_name(key) do
    clean =
      key
      |> to_string()
      |> String.replace("[", ".")
      |> String.replace("]", ".")
      |> String.replace("..", ".")
      |> String.trim_trailing(".")

    "data-bind-#{clean}"
  end

  def ds_parse_to_nested_json(str) do
    str
    |> String.split("[")
    |> Enum.map(&String.trim_trailing(&1, "]"))
    |> Enum.reverse()
    |> Enum.reduce(%{}, fn key, acc ->
      %{key => if(acc == %{}, do: [], else: acc)}
    end)
    |> Jason.encode!()
  end
end
