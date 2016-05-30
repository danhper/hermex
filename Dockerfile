FROM elixir:1.2.5

ENV MIX_ENV docker
RUN apt-get update -qq && apt-get install -y build-essential postgresql-client
RUN mix local.hex --force
RUN mix local.rebar --force
RUN mkdir /push-server
WORKDIR /push-server
ADD mix.exs /push-server/mix.exs
ADD mix.lock /push-server/mix.lock
RUN mix deps.get
RUN mix compile
ADD . /push-server
RUN mix compile
