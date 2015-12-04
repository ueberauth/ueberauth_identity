# Überauth Identity

> A simple username/password strategy for Überauth.

## Installation

1. Add `:ueberauth_identity` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ueberauth_identity, "~> 0.2"}]
    end
    ```

1. Add the strategy to your applications:

    ```elixir
    def application do
      [applications: [:ueberauth_identity]]
    end
    ```

1. Add Identity to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        identity: {Ueberauth.Strategy.Identity, []}
      ]
    ```

1.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller
      plug Ueberauth
      ...
    end
    ```

1.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/identity/callback", AuthController, :identity_callback
    end
    ```

1. Your request phase handler should implement a form or similar method to collect the required login information.

1. The controller callback should validate login information using the `Ueberauth.Auth` struct:

    ```elixir
    def identity_callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
      case validate_password(auth.credentials) do
        :ok ->
          user = %{id: auth.uid, name: name_from_auth(auth), avatar: auth.info.image}
          conn
          |> put_flash(:info, "Successfully authenticated.")
          |> put_session(:current_user, user)
          |> redirect(to: "/")
        { :error, reason } ->
          conn
          |> put_flash(:error, reason)
          |> redirect(to: "/")
      end
    end
    ```

For an example implementation see the [Überauth Example](https://github.com/ueberauth/ueberauth_example) application.

## Nested form attributes

Sometimes it's convenient to nest the returned params under a namespace. For
example if you're using a "user" form, your params may come back as:

```elixir
  %{ "user" => { "email" => "my@email.com" … }
```

If you're using a nested set of attributes like this you'll need to let
Überauth Identity know about it. To do this set an option in your config:

```elixir
    config :ueberauth, Ueberauth,
      providers: [
        identity: {Ueberauth.Strategy.Identity, [param_nesting: "user"]}
      ]
```

## Calling

Depending on the configured url you can initial the request through:

    /auth/identity

## License

Please see [LICENSE](https://github.com/ueberauth/ueberauth_identity/blob/master/LICENSE) for licensing details.
