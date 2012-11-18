# encoding: utf-8

require "bundler"
Bundler.require

require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths += %w[app]
