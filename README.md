# Thief

Thief is a hack and slash alternative for installing Gemfile contents as fast as possible. It
operates in following way:

  1. Runs `bundle check` which usually returns list of missing gems with versions quickly.
  2. Runs optimized `gem install` for each gem using as many parallel processes as you have CPUs.

## Installation

Install using the command line:

    $ gem install thief

## Usage

Recommended usage for CI builds or production installs is in combination with [Bundler](http://bundler.io/):

    $ thief; bundle check || bundle install

Execute somewhere where Gemfile is present

    $ thief

Or provide path to gemfile as an optional argument

    $ thief /path/to/some/Gemfile

## Contributing

1. Fork it ( https://github.com/[my-github-username]/thief/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
