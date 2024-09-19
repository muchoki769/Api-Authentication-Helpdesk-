defmodule Helpdesk.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource],
    domain: Helpdesk.Accounts

  # extensions: [AshJsonApi.Resource]

  # authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "tokens"
    repo Helpdesk.Repo
  end

  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
