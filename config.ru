require 'codebreaker'

class Application
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index"))
    else Rack::Response.new("Not Found", 404)
    end
  end

  def render(view)
    render_template('layouts/application') do
      render_template(view)
    end
  end

  def render_template(path, &block)
    ERB.new(File.read(File.expand_path("../app/views/#{path}.html.erb", __FILE__))).result(get_binding &block)
  end

  def get_binding
    binding
  end
end

use Rack::Reloader, 0
use Rack::Static, :urls => ["/stylesheets"], :root => "public"
run Application