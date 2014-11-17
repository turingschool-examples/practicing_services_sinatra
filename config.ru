$:.unshift Dir.pwd
require 'bundler'
Bundler.require

require './app'
require 'csv_parser'
run IdeaBoxApp
