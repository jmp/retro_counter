# RetroCounter

This is a simple retro-style visitor counter for websites.

You know, like one of those "0001513" images that shows how many visits the website
has had since the beginning of time.

## Run using Mix

First, install the dependencies:

    mix deps.get

Then run:

    mix run --no-halt

Access the counter at http://localhost:4000/count.svg.

## Why

It started as stupid idea. Who has visitor counters on their websites these days?
But it seemed like a small enough project to learn Elixir, so I decided why not.

The original idea was to store the current visitor count in a flat text file.
When a person visits the site, we would read the count from the file, increment
it by one, then write the new count back into the file.

There is one obvious problem with this approach. The file may get corrupted with
simultaneous reads and writes.

Then I realized Elixir has super powers. I can use a [GenServer][genserver] to hold the count
in memory all the time. Then, I can schedule a single, separate process whose only
job is to write the current value to the file at a scheduled interval (e.g. one hour).

Maybe this approach also has some downsides, but it was very simple to do in Elixir,
and relatively easy to test as well. Especially given that I had zero experience with
ExUnit before.

Anyway, this has been an fun learning experience and maybe it'll be interesting for
somebody else as well. So, here you go.

[genserver]: https://hexdocs.pm/elixir/GenServer.html
