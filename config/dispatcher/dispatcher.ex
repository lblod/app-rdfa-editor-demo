defmodule Dispatcher do
  use Plug.Router

  def start(_argv) do
    port = 80
    IO.puts "Starting Plug with Cowboy on port #{port}"
    Plug.Adapters.Cowboy.http __MODULE__, [], port: port
    :timer.sleep(:infinity)
  end

  plug Plug.Logger
  plug :match
  plug :dispatch

  # In order to forward the 'themes' resource to the
  # resource service, use the following forward rule.
  #
  # docker-compose stop; docker-compose rm; docker-compose up
  # after altering this file.
  #
  # match "/themes/*path" do
  #   Proxy.forward conn, path, "http://resource/themes/"
  # end

  match "/editor-documents/*path" do
    Proxy.forward conn, path, "http://resource/editor-documents/"
  end

  match "/templates/*path" do
    Proxy.forward conn, path, "http://resource/templates/"
  end

  match "/meetings/*path" do
    Proxy.forward conn, path, "http://resource/meetings/"
  end

  match "/memberships/*path" do
    Proxy.forward conn, path, "http://resource/memberships/"
  end

  match "/persons/*path" do
    Proxy.forward conn, path, "http://resource/persons/"
  end

  match "/roles/*path" do
    Proxy.forward conn, path, "http://resource/roles/"
  end

  match "/agendas/*path" do
    Proxy.forward conn, path, "http://resource/agendas/"
  end

  match "/agenda-items/*path" do
    Proxy.forward conn, path, "http://resource/agenda-items/"
  end

  match "/agenda-item-proceedings/*path" do
    Proxy.forward conn, path, "http://resource/agenda-item-proceedings/"
  end

  match "/action-items/*path" do
    Proxy.forward conn, path, "http://resource/action-item/"
  end

  match "/folders/*path" do
    Proxy.forward conn, path, "http://resource/folders/"
  end

  match "/documents/*path" do
    Proxy.forward conn, path, "http://resource/documents/"
  end

  ############
  # METAMODEl
  ############
  match "/rdfs-classes/*path" do
    Proxy.forward conn, path, "http://resource/rdfs-classes/"
  end

  match "/rdfs-properties/*path" do
    Proxy.forward conn, path, "http://resource/rdfs-properties/"
  end

  match _ do
    send_resp( conn, 404, "Route not found.  See config/dispatcher.ex" )
  end

end
