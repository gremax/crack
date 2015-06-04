require 'codebreaker'
require 'erb'
include ERB::Util

class Application
  def self.call(env)
    new(env).response.finish
  end

  def initialize(env)
    @request = Rack::Request.new(env)
  end

  def response
    case @request.path
    when "/"       then index
    when "/start"  then start
    when "/scores" then scores
    when "/submit" then submit
    else Rack::Response.new("Not Found", 404)
    end
  end

  def index
    Rack::Response.new(render("index"))
  end

  def start
    game.start
    @request.session[:matches] = []
    Rack::Response.new(render("index"))
  end

  def scores
    if @request.post?
      begin
        username = html_escape(@request.params["username"].strip)
        game.save(username, SCORES)
        message :info, "Thanks, #{username}! Your score has been saved!"
        Rack::Response.new(render("scores"))
      rescue => e
        message :danger, e
        Rack::Response.new(render("save"))
      end
    else
      Rack::Response.new(render("scores"))
    end
  end

  def submit
    guess = html_escape(@request.params["user_guess"].strip)
    matches << [guess, game.submit(guess)]
    if matches.last[1].eql?("++++")
      message :success, "Congratulations! You won!"
      Rack::Response.new(render("save"))
    elsif matches.last[1].eql?("Game over")
      message :warning, "Sorry! You lose!"
      Rack::Response.new(render("save"))
    else
      Rack::Response.new do |response|
        response.redirect("/")
      end
    end
  rescue => e
    message :danger, e
    Rack::Response.new(render("index"))
  end

  def render(view)
    render_template('layouts/application') { render_template(view) }
  end

  def render_template(path, &block)
    template = File.expand_path("../../app/views/#{path}.html.erb", __FILE__)
    ERB.new(File.read(template)).result(binding &block)
  end

  def hint
    game.hint
  rescue
    ""
  end

  def load_scores
    scores = game.scores(SCORES)
    scores.sort { |a,b| a.finish_at - a.start_at <=> b.finish_at - b.start_at }
  rescue
    []
  end

  def matches
    @request.session[:matches] ||= []
  end

  def game
    @request.session[:codebreaker] ||= Codebreaker::Game.new
  end

  def message(type, msg)
    @msg = [type, msg]
  end
end
