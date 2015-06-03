$LOAD_PATH << '.'
require 'lib/application'

SCORES = File.expand_path("../data/scores.db", __FILE__)
SECRET = ENV['RACK_ENV'] == 'development' ? 'secret' : ENV['SECRET_TOKEN']

use Rack::Reloader, 0
use Rack::Session::Cookie, :key => 'crack',
                           :expire_after => 3600,
                           :secret => SECRET
use Rack::Static, :urls => ["/stylesheets", "/javascripts"], :root => "public"
run Application
