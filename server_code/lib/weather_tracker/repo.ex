defmodule WeatherTracker.Repo do
  use Ecto.Repo,
    otp_app: :weather_tracker,
    adapter: Ecto.Adapters.Postgres
end
