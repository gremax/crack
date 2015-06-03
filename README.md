# Crack

Crack is an online (rack) version of the [Codebreaker](https://github.com/gremax/codebreaker) game.

## Installation

```bash
git clone https://github.com/gremax/crack.git
```

And then execute:

    $ cd crack && rackup

## Usage

Open browser and play:

    $ open http://localhost:9292

## Deploy on Heroku

    $ heroku create --eu

Generate `SECRET_TOKEN`:

    $ rake secret

Set a new environment varable:

    $ heroku config:set SECRET_TOKEN=96554406f406641c0a67bb7f18044b98c7f76eafa2d6dffaad30abd372ff2f2a9d523936ddbb81b9655bb841d886d878fff3a236eceea3a1accb9215467cbca5

Use git to deploy to Heroku:

    $ git push heroku master

Open browser and play:

    $ heroku open

## Rake tasks

     $ rake -T

```bash
rake db:remove  # Remove database file
rake db:reset   # Reset database
rake secret     # Generate a secret key
```

## Contributing

1. Fork it ( https://github.com/gremax/crack/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
