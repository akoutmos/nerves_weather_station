defmodule WeatherTrackerWeb.Router do
  use WeatherTrackerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", WeatherTrackerWeb do
    pipe_through :api

    post "/weather-conditions", WeatherConditionsController, :create
  end
end
