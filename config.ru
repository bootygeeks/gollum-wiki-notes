#!/usr/bin/env ruby
#
# config.ru:jeff
#
# rackup server config

Gollum::Page.send :remove_const,
  :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES

require 'bundler/setup'
require 'gollum/app'
require 'omnigollum'
require 'omniauth-google-oauth2'
# require 'omniauth/strategies/github'
require './config'
require './routes'

# Process ID; this will be necessary for our init.d script, gollum-server
File.open(ENV_PID_FILE, 'w') {
  |f| f.write Process.pid
}

# :omnigollum options *must* be set before the Omnigollum extension is
# registered
Precious::App.set(:gollum_path, ENV_GIT_ROOT)
Precious::App.set(:wiki_options, WIKI_OPTIONS)
Precious::App.set(:omnigollum, AUTH_OPTIONS)
Precious::App.register Omnigollum::Sinatra
# Original config
# Precious::App.run!(gollum_options)

# TODO(jeff): http://www.rubydoc.info/github/rack/rack/Rack/Handler/WEBrick#shutdown-class_method
# Rack::Handler.default.shutdown = TestShutdown.new

# http://stackoverflow.com/a/32595088
Rack::Handler.default.run(app, SERVER_OPTIONS)
