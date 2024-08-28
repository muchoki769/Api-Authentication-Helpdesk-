defmodule Helpdesk.Support.Ticket do
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  postgres do
    table "tickets"
    repo Helpdesk.Repo
  end

  json_api do
    type "ticket"

    routes do
      base "/tickets"

      get :read
      index :read
      post :open
      delete :destroy
    end
  end

  actions do
    defaults [:read]

    create :open do
      accept [:subject]
    end

    update :assign do
      accept [:representative_id]
    end

    update :close do
      accept []

      validate attribute_does_not_equal(:status, :closed) do
        message "Ticket is already closed"
      end

      change set_attribute(:status, :closed)
    end

    destroy :archive do
      soft? true
      change set_attribute(:archived_at, &DateTime.utc_now/0)
    end

    destroy :destroy
  end

  attributes do
    uuid_primary_key :id

    # attribute :subject, :string, allow_nil?: false, public?: true

    attribute :subject, :string do
      allow_nil? false

      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:open, :closed]

      default :open

      allow_nil? false
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :representative, Helpdesk.Support.Representative
  end
end
