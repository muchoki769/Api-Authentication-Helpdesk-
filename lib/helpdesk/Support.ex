defmodule Helpdesk.Support do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  json_api do
    prefix "/api/json"

    open_api do
      tag "Helpdesk.Support"

      group_by :domain
    end
  end

  resources do
    resource Helpdesk.Support.Ticket
    resource Helpdesk.Support.Representative
  end
end
