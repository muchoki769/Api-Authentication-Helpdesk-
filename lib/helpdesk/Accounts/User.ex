defmodule Helpdesk.Accounts.User do
  use Ash.Resource,
    domain: Helpdesk.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  # extensions: [AshJsonApi.Resource]

  # authorizers: [Ash.Policy.Authorizer],

  postgres do
    table "users"
    repo Helpdesk.Repo
  end

  authentication do
    strategies do
      password :password do
        identity_field :email

        resettable do
          sender Helpdesk.Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled? true
      token_resource Helpdesk.Accounts.Token
      signing_secret Helpdesk.Accounts.Secrets
      store_all_tokens? true
    end
  end

  # json_api do
  #   type "users"

  #   routes do
  #     base "/users"

  #     post :create
  #     get :show
  #     delete :destroy
  #   end
  # end

  actions do
    defaults [:read]

    create :create do
      accept [:email, :hashed_password]
      primary? true
    end
  end

  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end

  #   policy always() do
  #     forbid_if always()
  #   end
  # end

  attributes do
    uuid_primary_key :id, public?: true

    attribute :email, :ci_string do
      allow_nil? false
      public? true
    end

    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  # attribute :hashed_password, :string do
  #   allow_nil? false
  #   sensitive? true
  #   end
  # end

  identities do
    identity :unique_email, [:email], eager_check?: true
  end
end
