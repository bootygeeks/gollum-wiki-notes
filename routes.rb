#!/usr/bin/env ruby
#
# routes.rb:jeff
#
# Application HTTP routes

require './api.rb'

# https://github.com/gollum/gollum/wiki/Gollum-via-Rack
def app
  base_path = "/"

  Rack::Builder.new do
    map base_path do
      # run Proc.new { [302, { 'Location' => base_path }, []] }
      run Precious::App
    end

    map '/api' do
      run Api
    end

  end.to_app
end
