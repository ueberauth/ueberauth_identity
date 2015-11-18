# ÜberauthIdentity

Implements a simple strategy for Ueberauth useful for username/password
strategies.

Add to the config

````elixir

config :ueberauth, Ueberauth,
  providers: [
    identity: { Uerberauth.Strategy.Identity, [] }
  ]

# in your pipeline
Ueberauth.plug "/auth"
````

This will setup the request and callback phases at `/auth/identity` and
`/auth/identity/callback`.

You can modify the fields used to complete the `Ueberauth.Auth` struct by
passing options in your configuration.

````elixir
config :ueberauth, Ueberauth,
  providers: [
    identity: { Uerberauth.Strategy.Identity, [uid_field: :username, nickname_field: :username] }
  ]
````

You can change the http method for the callback with the `:methods` option

````elixir
config :ueberauth, Ueberauth,
  providers: [
    identity: { Uerberauth.Strategy.Identity, [methods: ["POST"]] }
  ]
````

Inside your request phase handler `/auth/identity` you should implement a form
or something similar to collect the required information.

Then in your callback you will have access to the `Ueberauth.Auth` struct

````elixir
get "/auth/identity/callback" do
  auth = conn.assigns.ueberauth_auth
  # lookup or create your user
  # |> Guardian.Plug.sign_in(user, :browser)
end
````

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add ueberauth_identity to your list of dependencies in `mix.exs`:

````elixir
def deps do
  [{:ueberauth_identity, "~> 0.0.1"}]
end
````

## License

The MIT License (MIT)

Copyright (c) 2015 Daniel Neighman

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
