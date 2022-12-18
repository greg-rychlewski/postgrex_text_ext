defmodule PSQL do
  @pg_env %{"PGUSER" => System.get_env("PGUSER") || "postgres"}

  def cmd(args) do
    {output, status} = System.cmd("psql", args, stderr_to_stdout: true, env: @pg_env)

    if status != 0 do
      IO.puts("""
      Command:

      psql #{Enum.join(args, " ")}

      error'd with:

      #{output}

      Please verify the user "postgres" exists and it has permissions to
      create databases and users. If not, you can create a new user with:

      $ createuser postgres -s --no-password
      """)

      System.halt(1)
    end

    output
  end
end

PSQL.cmd(["-c", "DROP DATABASE IF EXISTS postgrex_text_ext_test;"])
PSQL.cmd(["-c", "CREATE DATABASE postgrex_text_ext_test;"])

Application.put_env(:postgrex_text_ext, :type_names, ["uuid", "regconfig"])
Application.put_env(:postgrex_text_ext, :type_outputs, ["range_out"])

ExUnit.start()
