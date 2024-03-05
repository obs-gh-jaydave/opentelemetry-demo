# Copyright The OpenTelemetry Authors
# SPDX-License-Identifier: Apache-2.0


# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :featureflagservice,
  ecto_repos: [Featureflagservice.Repo]

# Configures the endpoint
config :featureflagservice, FeatureflagserviceWeb.Endpoint,
  url: [host: "localhost", path: "/feature"],
  render_errors: [view: FeatureflagserviceWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Featureflagservice.PubSub,
  live_view: [signing_salt: "T88WPl/Q"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :logger,
  level: :debug

# Configure Quantum scheduler for Featureflagservice
config :featureflagservice, Featureflagservice.Scheduler,
  jobs: [
    # Every 1 hour, set the feature flag to 1.0 for cartServiceFailure
    {"0 */1 * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["cartServiceFailure", 1.0]}},
    # Every 30 minutes, set the feature flag to 0.0 for cartServiceFailure
    {"*/30 * * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["cartServiceFailure", 0.0]}},
    # Every 1 hour, set the feature flag to 1.0 for productCatalogFailure
    {"0 */1 * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["productCatalogFailure", 1.0]}},
    # Every 30 minutes, set the feature flag to 0.0 for productCatalogFailure
    {"*/30 * * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["productCatalogFailure", 0.0]}},
    # Every 1 hour, set the feature flag to 1.0 for recommendationCache
    {"0 */1 * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["recommendationCache", 1.0]}},
    # Every 30 minutes, set the feature flag to 0.0 for recommendationCache
    {"*/30 * * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["recommendationCache", 0.0]}},
    # Every 1 hour, set the feature flag to 1.0 for adServiceFailure
    {"0 */1 * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["adServiceFailure", 1.0]}},
    # Every 30 minutes, set the feature flag to 0.0 for adServiceFailure
    {"*/30 * * * *", {Featureflagservice.FeatureFlags, :toggle_feature_flag, ["adServiceFailure", 0.0]}}
  ]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
