FROM elixir:1.2.4

RUN apt-get update
RUN apt-get install -y git locales
RUN sed -ie 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
RUN locale-gen

ENV LANG en_US.UTF-8
ENV MIX_ENV test
ENV DATABASE_URL postgres://postgres@postgres/postgres

RUN dpkg-reconfigure locales --frontend=noninteractive

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mkdir -p /root/.ssh

RUN echo -e ${SSH_KEY} > /root/.ssh/id_rsa

RUN chmod 600 /root/.ssh/id_rsa

RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan git.claudetech.com >> /root/.ssh/known_hosts

RUN echo 'Host git.claudetech.com\n\
  Hostname git.claudetech.com\n\
  StrictHostKeyChecking no\n\
  IdentityFile /root/.ssh/id_rsa' > /root/.ssh/config

RUN git clone git@git.claudetech.com:buildy/push-server.git

WORKDIR /push-server

RUN git checkout -b ci origin/ci

RUN mix deps.get

RUN mix compile

RUN mix test
