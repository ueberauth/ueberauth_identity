defmodule SpecRouter do
  require Ueberauth
  use Plug.Router

  plug(:fetch_query_params)

  plug(Ueberauth, base_path: "/auth")

  plug(:match)
  plug(:dispatch)

  get("/auth/identity", do: send_resp(conn, 200, "identity request"))

  get "/auth/identity_with_options" do
    send_resp(conn, 200, "identity with options request")
  end

  get("/auth/identity/callback", do: send_resp(conn, 200, "identity callback"))

  get "/auth/identity_with_options/callback" do
    send_resp(conn, 200, "identity with options callback")
  end

  get "/auth/identity_with_nested_options/callback" do
    send_resp(conn, 200, "identity with nested options callback")
  end
end

ExUnit.start()
