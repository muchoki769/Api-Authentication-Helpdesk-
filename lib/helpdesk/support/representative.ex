defmodule Helpdesk.Support.Representative do
  use Ash.Resource,
    domain: Helpdesk.Support,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "representatives"
    repo Helpdesk.Repo
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name]
    end
  end

  attributes do
    uuid_primary_key :id

    create_timestamp :created_at
    update_timestamp :updated_at

    attribute :name, :string do
      public? true
    end
  end

  relationships do
    has_many :tickets, Helpdesk.Support.Ticket
  end

  calculations do
    calculate :percent_open, :float, expr(open_tickets / total_tickets)
  end

  aggregates do
    count :total_ticket, :tickets

    count :open_tickets, :tickets do
      filter expr(status == :open)
    end

    count :closed_tickets, :tickets do
      filter expr(status == :closed)
    end
  end
end
