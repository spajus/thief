# Thief

Thief is a hack and slash alternative for installing Gemfile contents as fast as possible. It
operates in following way:

   1. Parses the `Gemfile`, ignoring `Gemfile.lock`, of course.
   2. Runs `gem install` for each gem using as many parallel processes as you have CPUs.

It leaves a mess, but does the majority of work that Bundler is notoriously slow at. Run Bundler
afterwards to have a clean finish.

## Installation

Install using the command line:

   $ gem install thief

## Usage

Recommended usage for CI builds or production installs is in combination with [Bundler](http://bundler.io/):

    $ bundle check || thief; bundle install

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
