defmodule Ueberauth.Strategy.IdentityTest do
  use ExUnit.Case
  use Plug.Test
  doctest Ueberauth.Strategy.Identity

  @router SpecRouter.init([])

  test "request phase" do
    conn = conn(:get, "/auth/identity") |> SpecRouter.call(@router)
    assert conn.resp_body == "identity request"
  end

  test "default callback phase" do
    opts = %{
      email: "foo@example.com",
      name: "Fred Flintstone",
      first_name: "Fred",
      last_name: "Flintstone",
      nickname: "freddy",
      phone: "555-555-5555",
      description: "Cave man",
      location: "Bedrock",
      password: "sekrit",
      password_confirmation: "sekrit"
    }
    query = URI.encode_query(opts)

    conn = conn(:get, "/auth/identity/callback?#{query}") |> SpecRouter.call(@router)

    assert conn.resp_body == "identity callback"

    auth = conn.assigns.ueberauth_auth

    assert auth.provider == :identity
    assert auth.strategy == Ueberauth.Strategy.Identity
    assert auth.uid == opts.email

    info = auth.info
    assert info.email == opts.email
    assert info.name == opts.name
    assert info.first_name == opts.first_name
    assert info.last_name == opts.last_name
    assert info.nickname == opts.nickname
    assert info.phone == opts.phone
    assert info.location == opts.location
    assert info.description == opts.description

    creds = auth.credentials
    assert creds.other.password == opts.password
    assert creds.other.password_confirmation == opts.password_confirmation

    extra = auth.extra

    assert extra.raw_info["email"] == opts.email
    assert extra.raw_info["name"] == opts.name
    assert extra.raw_info["first_name"] == opts.first_name
    assert extra.raw_info["last_name"] == opts.last_name
    assert extra.raw_info["nickname"] == opts.nickname
    assert extra.raw_info["phone"] == opts.phone
    assert extra.raw_info["location"] == opts.location
    assert extra.raw_info["description"] == opts.description
  end

  test "overwridden callback phase" do
    opts = %{
      email: "foo@example.com",
      name: "Fred Flintstone",
      first_name: "Fred",
      last_name: "Flintstone",
      username: "freddy",
      phone: "555-555-5555",
      description: "Cave man",
      location: "Bedrock",
      password: "sekrit",
      password_confirmation: "sekrit"
    }
    query = URI.encode_query(opts)

    conn = conn(:get, "/auth/identity_with_options/callback?#{query}") |> SpecRouter.call(@router)

    assert conn.resp_body == "identity with options callback"

    auth = conn.assigns.ueberauth_auth

    assert auth.provider == :identity_with_options
    assert auth.strategy == Ueberauth.Strategy.Identity
    assert auth.uid == opts.username

    info = auth.info
    assert info.email == opts.email
    assert info.name == opts.name
    assert info.first_name == opts.first_name
    assert info.last_name == opts.last_name
    assert info.nickname == opts.username
    assert info.phone == opts.phone
    assert info.location == opts.location
    assert info.description == opts.description
  end
end
