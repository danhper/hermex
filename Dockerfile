FROM elixir:1.4

ENV MIX_ENV prod
RUN apt-get update -qq && apt-get install -y build-essential postgresql-client
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mkdir /hermex
WORKDIR /hermex
COPY mix.exs /hermex/mix.exs
COPY mix.lock /hermex/mix.lock
RUN mix deps.get
RUN mix compile
COPY . /hermex
RUN mix compile
