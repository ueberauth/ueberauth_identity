defmodule Ueberauth.Strategy.IdentityTest do
  use ExUnit.Case
  use Plug.Test
  doctest Ueberauth.Strategy.Identity

  @router SpecRouter.init([])

  test "request phase" do
    conn =
      :get
      |> conn("/auth/identity")
      |> SpecRouter.call(@router)

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

    conn =
      :get
      |> conn("/auth/identity/callback?#{query}")
      |> SpecRouter.call(@router)

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

  test "overridden callback phase" do
    opts = %{
      "user[email]" => "foo@example.com",
      "user[name]" => "Fred Flintstone",
      "user[first_name]" => "Fred",
      "user[last_name]" => "Flintstone",
      "user[username]" => "freddy",
      "user[phone]" => "555-555-5555",
      "user[description]" => "Cave man",
      "user[location]" => "Bedrock",
      "user[password]" => "sekrit",
      "user[password_confirmation]" => "sekrit"
    }

    query = URI.encode_query(opts)

    conn =
      :get
      |> conn("/auth/identity_with_options/callback?#{query}")
      |> SpecRouter.call(@router)

    assert conn.resp_body == "identity with options callback"

    auth = conn.assigns.ueberauth_auth

    assert auth.provider == :identity_with_options
    assert auth.strategy == Ueberauth.Strategy.Identity
    assert auth.uid == Map.get(opts, "user[username]")

    info = auth.info
    assert info.email == Map.get(opts, "user[email]")
    assert info.name == Map.get(opts, "user[name]")
    assert info.first_name == Map.get(opts, "user[first_name]")
    assert info.last_name == Map.get(opts, "user[last_name]")
    assert info.nickname == Map.get(opts, "user[username]")
    assert info.phone == Map.get(opts, "user[phone]")
    assert info.location == Map.get(opts, "user[location]")
    assert info.description == Map.get(opts, "user[description]")
  end

  test "callback phase with nested params" do
    opts = %{
      "data[attributes][email]" => "foo@example.com",
      "data[attributes][name]" => "Fred Flintstone",
      "data[attributes][first_name]" => "Fred",
      "data[attributes][last_name]" => "Flintstone",
      "data[attributes][username]" => "freddy",
      "data[attributes][phone]" => "555-555-5555",
      "data[attributes][description]" => "Cave man",
      "data[attributes][location]" => "Bedrock",
      "data[attributes][password]" => "sekrit",
      "data[attributes][password_confirmation]" => "sekrit"
    }

    query = URI.encode_query(opts)

    conn =
      :get
      |> conn("/auth/identity_with_nested_options/callback?#{query}")
      |> SpecRouter.call(@router)

    assert conn.resp_body == "identity with nested options callback"

    auth = conn.assigns.ueberauth_auth

    assert auth.provider == :identity_with_nested_options
    assert auth.strategy == Ueberauth.Strategy.Identity
    assert auth.uid == Map.get(opts, "data[attributes][email]")

    info = auth.info
    assert info.email == Map.get(opts, "data[attributes][email]")
    assert info.name == Map.get(opts, "data[attributes][name]")
    assert info.first_name == Map.get(opts, "data[attributes][first_name]")
    assert info.last_name == Map.get(opts, "data[attributes][last_name]")
    assert info.nickname == Map.get(opts, "data[attributes][nickname]")
    assert info.phone == Map.get(opts, "data[attributes][phone]")
    assert info.location == Map.get(opts, "data[attributes][location]")
    assert info.description == Map.get(opts, "data[attributes][description]")
  end

  test "scrub params" do
    opts = %{
      email: "foo@example.com",
      name: ""
    }

    query = URI.encode_query(opts)

    conn =
      :get
      |> conn("/auth/identity/callback?#{query}")
      |> SpecRouter.call(@router)

    assert conn.resp_body == "identity callback"

    auth = conn.assigns.ueberauth_auth

    assert auth.provider == :identity
    assert auth.strategy == Ueberauth.Strategy.Identity
    assert auth.uid == opts.email

    info = auth.info
    assert info.email == opts.email
    assert info.name == nil

    extra = auth.extra
    assert extra.raw_info["email"] == opts.email
    assert extra.raw_info["name"] == opts.name
  end
end
