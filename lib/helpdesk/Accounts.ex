defmodule Helpdesk.Accounts do
  use Ash.Domain, extensions: [AshJsonApi.Domain]

  json_api do
    prefix "/api/json"

    open_api do
      tag "Helpdesk.Accounts"

      group_by :domain
    end
  end

  resources do
    resource Helpdesk.Accounts.User
    resource Helpdesk.Accounts.Token
  end
end
