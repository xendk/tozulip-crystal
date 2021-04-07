# tozulip-crystal

This is a [Crystal](https://crystal-lang.org/) re-implementation of
[ToZulip](https://github.com/xendk/tozulip) created to get a taste of
the Crystal programming language.

There is a few differences:

ToZulip-crystal doesn't support a YAML configuration file. The
original Go implementation only did because it was a feature of the
[Viper](https://github.com/spf13/viper) library. As there's no library
that provides the same functionality out of the box, and I don't
really see the utility considering the commands intended usage, I
skipped that part.

ToZulip-crystal has tests, the Go version didn't. It's properly down
to personal experience, but I found Crystals standard spec testing
more approachable that Gos built in testing, partly because I spent
less time trying to figure out how to implement the command.

The rest of this file is the standard content added by the `crystal
init` command.

## Installation

TODO: Write installation instructions here

## Usage

TODO: Write usage instructions here

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/xendk/tozulip-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Thomas Fini Hansen](https://github.com/xendk) - creator and maintainer
