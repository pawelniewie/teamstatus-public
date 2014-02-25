require Rails.root.join('config', 'environments', 'production')

Public::Application.configure do
  config.action_dispatch.tld_length = 2
end
