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

  db_user = System.get_env("DB_USERNAME")
  db_pass = System.get_env("DB_PASSWORD")
  db_name = System.get_env("DB_DATABASE")
  db_host = System.get_env("DB_HOSTNAME")
  db_port = String.to_integer(System.get_env("DB_PORT") || "5432")

  config :chorerw, Chorerw.Repo,
    username: db_user,
    password: db_pass,
    database: db_name,
    hostname: db_host,
    port: db_port,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
end
