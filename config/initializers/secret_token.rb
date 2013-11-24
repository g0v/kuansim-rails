# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Kuansim::Application.config.secret_token = ENV["SECRET_TOKEN"] || '5621d1db22b7994c5c1443fd8140202ca09f60163e6ef8aa9c8a9d92f19386588da7b00a15f75515e78faa60054a305de7c91678f2e24929ed87f79766127457'
