[
  import_deps: [
    :ash,
    :ecto,
    :ecto_sql,
    :phoenix,
    :ash_json_api,
    :ash_postgres,
    :ash_authentication,
    :picosat_elixir,
    :ash_authentication_phoenix
  ],
  subdirectories: ["priv/*/migrations"],
  plugins: [Spark.Formatter, Phoenix.LiveView.HTMLFormatter],
  inputs: ["*.{heex,ex,exs}", "{config,lib,test}/**/*.{heex,ex,exs}", "priv/*/seeds.exs"]
]
