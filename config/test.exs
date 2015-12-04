use Mix.Config

config :ueberauth, Ueberauth,
  providers: [
    identity: { Ueberauth.Strategy.Identity, [] },
    identity_with_options: {
      Ueberauth.Strategy.Identity,
      [
        uid_field: :username,
        nickname_field: :username,
        param_nesting: "user"
      ]
    }
  ]
