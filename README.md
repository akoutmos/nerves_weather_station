# Build a Weather Station with Elixir and Nerves

## Introduction

This repository contains the companion code for the PragmaticBookshelf book "Build a Weather Station with Elixir and
Nerves"

The code base is organized into three parts for each of the components of the project. Those three parts being:

- `nerves_code`
  - The Nerves application that is deployed to the Raspberry Pi
- `server_code`
  - The server-side Phoenix application that is used to collect time-series weather data from the Nerves device
- `misc_code`
  - Miscellaneous code used in the project like the Grafana dashboard for presenting the Nerves weather data
