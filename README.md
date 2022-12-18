# PostgrexTextExt

Text extensions for the Postgrex driver.

Documentation: http://hexdocs.pm/postgrex_text_ext/

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

This library allows users to control which data types Postgrex will transmit using the text protocol. It works for all available types in PostgreSQL, even if their binary protocol is not supported by Postgrex.

Some reasons you might want to do this:

- It's not easy to obtain the data's binary version. For example, [to_tsvector](https://www.postgresql.org/docs/current/textsearch-controls.html) expects an OID as its first argument. If using the binary protocol, this value will have to be sent as an integer. If using the text protocol, the value can be sent as a string. i.e. `to_tsvector(1, 'some text')` (binary) vs `to_tsvector('english', 'some text')` (text).

- You may be using a PostgreSQL extension that doesn't have a binary protocol. For instance, the [https://www.postgresql.org/docs/current/ltree.html](ltree) extension started out only having a text protocol.

- The data's text version is more readily available to you. For instance, if using Postgrex directly instead of Ecto, it may be easier for you to work with a UUID's text representation.



## Usage


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
