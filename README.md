# PostgrexTextExt

[![Build Status](https://github.com/greg-rychlewski/postgrex_text_ext/workflows/CI/badge.svg)](https://github.com/greg-rychlewski/postgrex_text_ext/actions)

Text extensions for the Postgrex driver.

Documentation: https://hexdocs.pm/postgrex_text_ext

## Installation

Add `postgrex_text_ext` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:postgrex_text_ext, "~> 0.1.0"}
  ]
end
```

## About

This library allows you to control which data types Postgrex will transmit using the text protocol. It works for all available types in PostgreSQL, even if their binary protocol is not supported by Postgrex.

Some reasons you might want to do this:

- It's not easy to obtain the data's binary version. For example, [to_tsvector](https://www.postgresql.org/docs/current/textsearch-controls.html) expects an OID as its first argument. If using the binary protocol, this value will have to be sent as an integer. If using the text protocol, the value can be sent as a string. i.e. `to_tsvector(1, 'some text')` (binary) vs `to_tsvector('english', 'some text')` (text).

- You may be using a PostgreSQL extension that doesn't have a binary protocol. For instance, the [ltree](https://www.postgresql.org/docs/current/ltree.html) extension started out only having a text protocol.

- The data's text version is more readily available to you. For instance, if using Postgrex directly instead of Ecto, it may be easier for you to work with a UUID's text representation.

## Caution

Postgrex can transmit a data type using either the text or the binary protocol, but not both. Specifying a type in this library will make it so that it is always transmitted using the text protocol in all queries. This may cause unexpected results if you are not careful.

## Usage

Your application configuration is used to specify which data types should be transmitted using the text protocol. There are 2 levels of granularity you may use: type name and type output. These correspond to the `typname` and `typoutput` columns in the [pg_type system catalog](https://www.postgresql.org/docs/current/catalog-pg-type.html).

Type name is the most granular level of specification and is unique for each data type. Type output is less granular and groups data types by the conversion function used by PostgreSQL.

For example, an array of booleans has type name `_bool` and an array of UUIDs has type name `_uuid`. However, they both have type output `array_out`. Use type output if you'd like an entire group of data types to use the text protocol. Otherwise, list the type names individually.

A list of type names and outputs is [provided here](pg_type.md). You may also use the `pg_type` system catalog: `SELECT typname, typoutput FROM pg_type;`. 

Example configuration:

```elixir
  config :postgrex_text_ext,
    type_names: ["regconfig", "ltree"],
    type_outputs: ["range_out"]
```

Finally, you must define a custom type module, [as requred by Postgrex](https://hexdocs.pm/postgrex/readme.html#extensions), with extension `PostgrexTextExt`:

```elixir
Postgrex.Types.define(MyApp.PostgrexTypes, [PostgrexTextExt], [])
```

## Ecto

Schemas can use the text protocol by simply defining a field's type as `:string`. However, this won't be enough to catch invalid input during casting. 

For instance, you won't be able to tell if a text array is missing a closing bracket: `{1, 2, 3`. In this case, you won't find out until you receive an error from PostgreSQL.

For more intelligent validation, a [custom Ecto Type](https://hexdocs.pm/ecto/Ecto.Type.html) can be created.

## License

Copyright (c) 2022 Greg Rychlewski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
