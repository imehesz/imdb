require 'rubygems'
require 'fakeweb'
require File.expand_path(File.join(File.dirname(__FILE__), %w[.. lib imdb]))

FakeWeb.allow_net_connect = false

def site_file(filename)
  File.join(File.dirname(__FILE__), %W[fixtures #{filename}])
end

