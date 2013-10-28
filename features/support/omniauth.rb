Before('@omniauth_test') do
 
  # the symbol passed to mock_auth is the same as the name of the provider set up in the initializer
  OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
    provider: "google_oauth2",
    uid: "2134",
    info: {email: "dont@mail.me", name: "Heyo"}
    })

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    provider: "facebook",
    uid: "2134",
    extra: {raw_info: {name: "heyo"}},
    info: {email: "dont@mail.me"}
    })
end