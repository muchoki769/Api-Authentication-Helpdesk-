defmodule Helpdesk.Repo do
  import AshPostgres.Repo

  use AshPostgres.Repo, otp_app: :helpdesk

  def installed_extensions do
    ["ash-functions", "uuid-ossp", "citext"]
  end
end
