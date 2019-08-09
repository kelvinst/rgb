defmodule RGB do
  def parse("#" <> hex), do: parse(hex)

  def parse(hex) do
    {r, _} = hex |> String.slice(0, 2) |> Integer.parse(16)
    {g, _} = hex |> String.slice(2, 2) |> Integer.parse(16)
    {b, _} = hex |> String.slice(4, 2) |> Integer.parse(16)

    {r, g, b}
  end

  def to_string({r, g, b}) do
    "##{value_to_string(r)}#{value_to_string(g)}#{value_to_string(b)}"
  end

  def gradient(from, to, count \\ 2, include_to \\ true) do
    acc = if include_to, do: [to], else: []
    generate_gradient(from, to, count, acc)
  end

  defp generate_gradient(from, _, 1, acc) do
    Enum.map([from | acc], fn {r, g, b} ->
      {abs(r), abs(g), abs(b)}
    end)
  end

  defp generate_gradient({fr, fg, fb} = from, {tr, tg, tb}, c, acc) do
    new_color = {gradient_value(fr, tr, c), gradient_value(fg, tg, c), gradient_value(fb, tb, c)}
    generate_gradient(from, new_color, c - 1, [new_color | acc])
  end

  defp gradient_value(from, to, count) do
    to - round((to + from) / count)
  end

  defp value_to_string(value) do
    value
    |> Integer.to_string(16)
    |> String.pad_leading(2, "0")
  end

  def multi_gradient(list, count \\ 2, include_to \\ true) do
    list
    |> generate_multi_gradient(count, [], include_to)
    |> Enum.reverse()
    |> List.flatten()
  end

  defp generate_multi_gradient([_], _, acc, false), do: acc
  defp generate_multi_gradient([to], _, acc, true), do: [to | acc]

  defp generate_multi_gradient([from, to | rest], count, acc, include_to) do
    new_acc = [gradient(from, to, count, false) | acc]
    generate_multi_gradient([to | rest], count, new_acc, include_to)
  end
end
