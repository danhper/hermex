setup:
	mix ecto.create
	mix ecto.migrate

dependencies:
	mix deps.get

compile: dependencies
	mix compile
