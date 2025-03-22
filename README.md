# RetroCounter

This is a simple retro-style visitor counter for websites.
It started as a stupid idea. Who has visitor counters on their websites these days?
But it seemed like a small enough project to learn Elixir, so I decided, why not?
The original idea was to store the current visitor count in a flat text file.
When a person visits the site, we would read the count from the file, increment
it by one, then write the new count back into the file.

There is one obvious problem with this approach. The file may get corrupted with
simultaneous reads and writes.

Then I realized Elixir has superpowers. I can use a [GenServer][genserver] to hold the count
in memory all the time. It also means I have a single process at a time writing to the file.
As an extra bonus, you can defer writing by some delay (e.g., 30 seconds) to make sure we don't
write to the file on every counter increment.

Maybe this approach also has some downsides, but it was very simple to do in Elixir,
and relatively easy to test as well, especially given that I had zero experience with
ExUnit before.

Anyway, this has been a fun learning experience and maybe it'll be interesting for
somebody else as well. So, here you go.

## Requirements

* Elixir (see `mix.exs` for version)

## Run using Mix

First, install the dependencies:

    mix deps.get

Then run:

    mix run --no-halt

Access the counter at http://localhost:4000/count.svg.

## Configuration

You can configure the server with environment variables:

| Environment variable        | Default value | Description                                      |
| --------------------------- | ------------- | ------------------------------------------------ |
| `RETRO_COUNTER_PORT`        | `4000`        | Port for the HTTP server.                        |
| `RETRO_COUNTER_PATH`        | `count.txt`   | Path to where the current count will be stored.  |
| `RETRO_COUNTER_WRITE_DELAY` | `30000`       | Number of milliseconds to defer writing to file. |

## Run tests

    mix test

[genserver]: https://hexdocs.pm/elixir/GenServer.html
