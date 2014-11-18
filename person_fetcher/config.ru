$:.unshift Dir.pwd
require 'bundler'
Bundler.require

require 'app'
require 'person_fetcher'
run FetcherApp
