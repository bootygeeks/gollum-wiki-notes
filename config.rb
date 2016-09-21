#!/usr/bin/env ruby
#
# config.rb:jeff
#
# Environment configuration

require 'dotenv'

# Sources environment from .env
Dotenv.load

# Process ID
ENV_PID_FILE = ENV["PID_FILE"] ||= './notes.pid'

# Notes repo root
ENV_GIT_ROOT = ENV["GIT_ROOT"] ||=
  File.expand_path(File.join(File.dirname(__FILE__), 'notes.git'))

ENV_BARE_GIT_ROOT = ENV["BARE_GIT_ROOT"] ||= false

# Net server options
ENV_HOST = ENV["GOLLUM_HOST"] ||= '0.0.0.0'
ENV_PORT = ENV["GOLLUM_PORT"] ||= '4567'

# User authentication
ENV_CLIENT_ID = ENV["GOLLUM_CLIENT_ID"] ||= ''
ENV_CLIENT_SECRET = ENV["GOLLUM_CLIENT_SECRET"] ||= ''
ENV_GOLLUM_REDIRECT_URI = ENV["GOLLUM_CLIENT_REDIRECT_URL"] ||= ''
ENV_USERS = ENV["GOLLUM_AUTHORIZED_USERS"] ||= 'i8degrees@gmail.com'

# Create the authorized users list from the passed in environment
users = ENV_USERS.split(";")
users.each do |ch|
  ch.strip
end
GOLLUM_AUTH_USERS = users

# IMPORTANT(jeff): Session cookie
ENV_COOKIE_SECRET = ENV['RACK_COOKIE_SECRET'] ||= 'notagoodcookiesecret'

WIKI_OPTIONS = {
  :live_preview => false,
  :allow_uploads => true,
  :per_page_uploads => true,
  :allow_editing => true,
  :css => true,
  :js => true,
  :mathjax => true,
  :h1_title => true,
  :universal_toc => false,
  :repo_is_bare => ENV_BARE_GIT_ROOT
}

SERVER_OPTIONS = {
  :Host => ENV_HOST,
  :Port => ENV_PORT
}

AUTH_OPTIONS = {

  # OmniAuth::Builder block is passed as a proc
  :providers => Proc.new do
    # provider :github,
    # ENV_CLIENT_ID,
    # ENV_CLIENT_SECRET

    provider :google_oauth2,
    ENV_CLIENT_ID,
    ENV_CLIENT_SECRET,
    {
      # :access_type => 'online',
      :scope => "email",
      :prompt => "select_account",
      :redirect_uri => ENV_GOLLUM_REDIRECT_URI,
      :image_aspect_ratio => "original",
      :image_size => 50,
      # FIXME(jeff): By letting the provider ignore the 'state' of the app, we
      # open ourselves up to CSRF attacks.
      # https://github.com/intridea/omniauth-oauth2/issues/58
      # https://github.com/intridea/omniauth-oauth2/issues/32
      :provider_ignores_state => true
    }
  end,

  :dummy_auth => false,

  # Pages that require user authentication; see also: :authorized_users
  :protected_routes => [
    '/*'
    # '/revert/*',
    # '/revert',
    # '/create/*',
    # '/create',
    # '/edit/*',
    # '/edit',
    # '/rename/*',
    # '/rename',
    # '/delete/*',
    # '/delete'
  ],

  # Use the authenticated user name and e-mail for the page's commit
  :author_format => Proc.new { |user| user.name },
  :author_email => Proc.new { |user| user.email },

  # List of authorized users
  :authorized_users => GOLLUM_AUTH_USERS
}
