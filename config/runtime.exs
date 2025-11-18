import Config

if config_env() == :prod do
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one with: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST")
  port = String.to_integer(System.get_env("PHX_PORT") || "4000")

  config :chorerw, ChorerwWeb.Endpoint,
    server: true,
    url: [host: host, port: 443, scheme: "https"],
    http: [port: port],
    secret_key_base: secret_key_base,
    check_origin: [
      System.get_env("PHX_ORIGIN") || "https://#{host}"
    ]

  config :chorerw, Chorerw.Repo,
    username: System.get_env("DB_USERNAME"),
    password: System.get_env("DB_PASSWORD"),
    database: System.get_env("DB_DATABASE"),
    hostname: System.get_env("DB_HOSTNAME"),
    port: String.to_integer(System.get_env("DB_PORT") || "5432"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
