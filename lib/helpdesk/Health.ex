defmodule Helpdesk.Health do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  json_api do
    prefix "/api/json"

    open_api do
      tag "Helpdesk.Health"

      group_by :domain
    end
  end

  resources do
    resource Helpdesk.Health.Patient
    resource Helpdesk.Health.Facility
  end
end
