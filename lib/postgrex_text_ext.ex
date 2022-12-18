defmodule PostgrexTextExt do
  @moduledoc false

  @behaviour Postgrex.Extension

  @impl true
  def init(opts) do
    Keyword.get(opts, :decode_copy, :copy)
  end

  @impl true
  def format(_), do: :text

  @impl true
  def matching(_) do
    type_names = Application.get_env(:postgrex_text_ext, :type_names, [])
    type_outputs = Application.get_env(:postgrex_text_ext, :type_outputs, [])
    create_matching(type_names, type_outputs, [])
  end

  @impl true
  def encode(_) do
    quote do
      bin when is_binary(bin) ->
        [<<byte_size(bin)::signed-size(32)>> | bin]
    end
  end

  @impl true
  def decode(:reference) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        bin
    end
  end

  @impl true
  def decode(:copy) do
    quote do
      <<len::signed-size(32), bin::binary-size(len)>> ->
        :binary.copy(bin)
    end
  end

  # Helpers

  defp create_matching([], [], acc), do: Enum.reverse(acc)

  defp create_matching([], [output | outputs], acc) do
    create_matching([], outputs, [{:output, output} | acc])
  end

  defp create_matching([name | names], outputs, acc) do
    create_matching(names, outputs, [{:type, name} | acc])
  end
end
