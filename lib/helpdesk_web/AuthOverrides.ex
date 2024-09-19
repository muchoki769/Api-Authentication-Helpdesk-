defmodule HelpdeskdeskWeb.AuthOverrides do
  use AshAuthentication.Phoenix.Overrides

  override AshAuthentication.Phoenix.Components.Banner do
    set :image_url, "/images/rickroll.gif"
  end
end
