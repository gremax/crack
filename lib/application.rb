require 'codebreaker'

class Application
  attr_reader :hint
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/" then Rack::Response.new(render("index"))
    when "/start"
      game.start
      @request.session[:guesses] = []
      Rack::Response.new do |response|
        response.redirect("/")
      end
    when "/hint"
      Rack::Response.new do |response|
        response.redirect("/")
      end
    when "/submit"
      begin
        guesses << [@request.params["user_guess"], game.submit(@request.params["user_guess"].strip)]
        Rack::Response.new do |response|
          response.redirect("/")
        end
      rescue => e
        @error = e
        Rack::Response.new(render("index"))
      end
    else Rack::Response.new("Not Found", 404)
    end
  end

  def render(view)
    render_template('layouts/application') do
      render_template(view)
    end
  end

  def render_template(path, &block)
    template = File.expand_path("../../app/views/#{path}.html.erb", __FILE__)
    ERB.new(File.read(template)).result(get_binding &block)
  end

  private

  def get_binding
    binding
  end

  def guesses
    @request.session[:guesses] ||= []
  end

  def game
    @request.session[:codebreaker] ||= Codebreaker::Game.new
  end
end
