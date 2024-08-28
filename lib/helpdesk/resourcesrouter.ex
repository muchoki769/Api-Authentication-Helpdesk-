defmodule HelpdeskWeb.JsonApiRouter do
  use AshJsonApi.Router,
    domains: [Helpdesk.Support, Helpdesk.Health, Helpdesk.Accounts],
    open_api: "/open_api"
end

# (["Helpdesk.Support"]),
# domains: [Module.concat (["Helpdesk.Health"])]
