$:.unshift Dir.pwd
require 'bundler'
Bundler.require

require "./app"
require "printer"
run PrinterApp
