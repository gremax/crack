$LOAD_PATH << '.'
require 'lib/application'

use Rack::Reloader, 0
use Rack::Session::Cookie, :key => 'crack',
                           :secret => 'secret'
use Rack::Static, :urls => ["/stylesheets"], :root => "public"
run Application
