defmodule Helpdesk.Health.Patient do
  use Ash.Resource,
    domain: Helpdesk.Health,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  def create_patient(name, age, gender) do
    Helpdesk.Health.Patient
    |> Ash.Changeset.for_create(:create, %{
      name: name,
      age: age,
      gender: gender,
      facility_id: "68e881cf-b42f-4c06-93e0-2786bb1956d8"
    })
    |> Ash.create()
  end

  postgres do
    table "patients"
    repo Helpdesk.Repo
  end

  json_api do
    type "patients"

    routes do
      base "/patients"

      get :read
      index :read
      post :create
      delete :destroy
      # patch :update
    end
  end

  actions do
    defaults [:read]

    create :create do
      accept [:name, :age, :gender]

      primary? true

      argument :facility_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:facility_id, :facility, type: :append_and_remove)
    end

    update :assign do
      accept [:facility_id]
    end

    update :notadmitted do
      accept []

      validate attribute_does_not_equal(:status, :notadmitted) do
        message "Patient is not admitted"
      end

      change set_attribute(:status, :notadmitted)
    end

    update :admitted do
      accept []

      validate attribute_does_not_equal(:status, :admitted) do
        message "Patient  admitted"
      end

      change set_attribute(:status, :admitted)
    end

    destroy :archive do
      soft? true
      change set_attribute(:archived_at, &DateTime.utc_now/0)
    end

    destroy :destroy
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false

      public? true
    end

    attribute :gender, :string do
      allow_nil? false

      public? true
    end

    attribute :age, :integer do
      allow_nil? false

      public? true
    end

    attribute :facility_id, :uuid do
      allow_nil? false
      public? true
    end

    attribute :status, :atom do
      constraints one_of: [:admitted, :notadmitted]

      default :admitted

      allow_nil? false
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :facility, Helpdesk.Health.Facility do
      source_attribute :facility_id
      destination_attribute :id
    end
  end
end
