defmodule PostgrexTextExtTest do
  use ExUnit.Case

  @type_module TestTypeModule

  setup_all do
    on_exit(fn ->
      :code.delete(@type_module)
      :code.purge(@type_module)
    end)

    Postgrex.TypeModule.define(@type_module, [PostgrexTextExt], [])
    :ok
  end

  setup do
    opts = [
      database: "postgrex_text_ext_test",
      backoff_type: :stop,
      types: @type_module
    ]

    {:ok, pid} = Postgrex.start_link(opts)
    {:ok, [pid: pid]}
  end

  test "encodes by type name", context do
    [uuid, regconfig] = ["123e4567-e89b-12d3-a456-426614174000", "english"]
    result = Postgrex.query!(context.pid, "select $1::uuid, $2::regconfig", [uuid, regconfig])
    assert [[uuid, regconfig]] == result.rows

    result = Postgrex.query!(context.pid, "select to_tsvector($1, 'a fat cat')", [regconfig])
    assert [[[%Postgrex.Lexeme{}, %Postgrex.Lexeme{}]]] = result.rows
  end

  test "decodes by type name", context do
    [uuid, regconfig] = ["123e4567-e89b-12d3-a456-426614174000", "english"]

    result =
      Postgrex.query!(
        context.pid,
        "select '123e4567-e89b-12d3-a456-426614174000'::uuid, 'english'::regconfig",
        []
      )

    assert [[uuid, regconfig]] == result.rows
  end

  test "encodes by type output", context do
    range = "[2,5)"
    result = Postgrex.query!(context.pid, "select $1::int4range", [range])
    assert [[range]] == result.rows
  end

  test "decodes by type output", context do
    range = "[2,5)"
    result = Postgrex.query!(context.pid, "select '[2,5)'::int4range", [])
    assert [[range]] == result.rows
  end

  test "encodes a mixture of text and binary types", context do
    [uuid, regconfig, int_array] = ["123e4567-e89b-12d3-a456-426614174000", "english", [1, 2, 3]]

    result =
      Postgrex.query!(context.pid, "select $1::uuid, $2::regconfig, $3::int[]", [
        uuid,
        regconfig,
        int_array
      ])

    assert [[uuid, regconfig, int_array]] == result.rows
  end

  test "decodes a mixture of text and binary types", context do
    [uuid, regconfig, int_array] = ["123e4567-e89b-12d3-a456-426614174000", "english", [1, 2, 3]]

    result =
      Postgrex.query!(
        context.pid,
        "select '123e4567-e89b-12d3-a456-426614174000'::uuid, 'english'::regconfig, '{1, 2, 3}'::int[]",
        []
      )

    assert [[uuid, regconfig, int_array]] == result.rows
  end
end
