#!/usr/bin/env ruby
#
# api.rb:jeff
#
# API route

require 'rubygems'
require 'sinatra/base'
require './config'

class Api < Sinatra::Base
  # use Rack::Auth::Basic, "Restricted Area" do |username, password|
    # [username, password] == ['admin', 'admin']
  # end

  # ['/create/*','/edit/*'].each do |path|
    # before path do
      # redirect '/auth'
    # end
  # end # end def

  configure :development, :staging, :production do
    set :views, 'views'
    set :public_folder, 'public'
    set :site_name, 'notes'
    set :site_description, '...'
    set :author, 'Jeffrey Carpenter'
    set :author_email, 'i8degrees@gmail.com'
    set :reload_templates, true
    set :sessions, true
    set :session_secret, ENV_COOKIE_SECRET
    mime_type :text, 'text/plain'
    set :Host, ENV_HOST
    set :Port, ENV_PORT
    set :raise_errors, true
    set :show_exceptions, true
    set :dump_errors, true
    set :clean_trace, true
  end

  use Rack::Session::Cookie,
    :key => 'rack.session',
    :secret => ENV_COOKIE_SECRET,
    :expire_after => (1 * 365 * 24 * 60 * 60) # 31,536,000

  # /api
  get '/' do
    'online'
  end

  # /api/status
  get '/status' do
    'online'
  end
end
