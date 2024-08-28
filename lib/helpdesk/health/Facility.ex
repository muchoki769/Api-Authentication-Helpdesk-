defmodule Helpdesk.Health.Facility do
  use Ash.Resource,
    domain: Helpdesk.Health,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  require Ash.Sort
  require Ash.Query

  @default_attributes [
    :name,
    :county,
    :subcounty,
    :total_patients,
    :admitted_patients,
    :percent_admitted
  ]

  postgres do
    table "facility"
    repo Helpdesk.Repo
  end

  json_api do
    type "facility"

    routes do
      base "/facility"

      get :read, default_fields: @default_attributes
      index :read, default_fields: @default_attributes
      post :create
      delete :destroy
      # patch :update
    end
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :county, :subcounty]
      primary? true
    end

    update :update do
      accept [:name, :county]
      primary? true
    end

    destroy :archive do
      soft? true
      change set_attribute(:archived_at, &DateTime.utc_now/0)
    end

    destroy :destroy
  end

  preparations do
    prepare build(
              load: [
                :total_patients,
                :admitted_patients,
                :notadmitted_patients,
                :percent_admitted
              ]
            )
  end

  attributes do
    uuid_primary_key :id

    create_timestamp :created_at
    update_timestamp :updated_at

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :county, :string do
      allow_nil? false
      public? true
    end

    attribute :subcounty, :string do
      allow_nil? false
      public? true
    end
  end

  relationships do
    has_many :patients, Helpdesk.Health.Patient do
      source_attribute :id
      destination_attribute :facility_id
    end
  end

  calculations do
    # expr means code will be done from the postgresql,COALESCE means the number divided if it returns a zero it will not be outputted
    calculate :percent_admitted,
              :float,
              expr(fragment("? / COALESCE(NULLIF(?, 0), 1)", admitted_patients, total_patients))
  end

  aggregates do
    count :total_patients, :patients

    count :admitted_patients, :patients do
      filter expr(status == :admitted)
    end

    count :notadmitted_patients, :patients do
      filter expr(status == :notadmitted)
    end
  end
end
