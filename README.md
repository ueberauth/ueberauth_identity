# Üeberauth Identity

[![Build Status](https://travis-ci.org/ueberauth/ueberauth_identity.svg?branch=master)](https://travis-ci.org/ueberauth/ueberauth_identity)
[![Module Version](https://img.shields.io/hexpm/v/ueberauth.svg)](https://hex.pm/packages/ueberauth)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ueberauth/)
[![Total Download](https://img.shields.io/hexpm/dt/ueberauth.svg)](https://hex.pm/packages/ueberauth)
[![License](https://img.shields.io/hexpm/l/ueberauth.svg)](https://github.com/ueberauth/ueberauth/blob/master/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/ueberauth/ueberauth.svg)](https://github.com/ueberauth/ueberauth/commits/master)

> A simple username/password strategy for Überauth.

## Installation

1.  Add `:ueberauth_identity` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [
        {:ueberauth_identity, "~> 0.3"}
      ]
    end
    ```

2.  Add the strategy to your applications:

    ```elixir
    def application do
      [
        applications: [:ueberauth_identity]
      ]
    end
    ```

3.  Add Identity to your Überauth configuration:

    ```elixir
    config :ueberauth, Ueberauth,
      providers: [
        identity: {Ueberauth.Strategy.Identity, [
          callback_methods: ["POST"]
        ]}
      ]
    ```

4.  Include the Überauth plug in your controller:

    ```elixir
    defmodule MyApp.AuthController do
      use MyApp.Web, :controller
      plug Ueberauth
      ...
    end
    ```

5.  Create the request and callback routes if you haven't already:

    ```elixir
    scope "/auth", MyApp do
      pipe_through :browser

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/identity/callback", AuthController, :identity_callback
    end
    ```

6. Your request phase handler should implement a form or similar method to collect the required login information.

7.  The controller callback should validate login information using the `Ueberauth.Auth` struct:

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

## Params scrubbing

By default Überauth Identity will be changing empty values from the returned
params to nil.
If you want to disable that behaviour set the following option in your config:

```elixir
config :ueberauth, Ueberauth,
  providers: [
    identity: {Ueberauth.Strategy.Identity, [scrub_params: false]}
  ]
```

## Calling

Depending on the configured url you can initial the request through:

    /auth/identity/callback

## Copyright and License

Copyright (c) 2015 Daniel Neighman

Released under the MIT License, which can be found in the repository in [LICENSE](./LICENSE).
