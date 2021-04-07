require "colorize"
require "./cli"

# The Tozulip module simply calls Tozulip::Cli.run, and handles
# exceptions.
module Tozulip
  begin
    Tozulip::Cli.run(ARGV, STDOUT)
  rescue ex : Exit
    # We need the message in a local variable, as the compiler can't
    # be sure that `ex.message` is non-nil in `ex.message.nil? ||
    # ex.message.empty?`. Which makes sense when you think about it.
    message = ex.message
    puts message unless message.nil? || message.empty?
    # Fall throgh to a normal exit.
  rescue ex : Abort
    abort ex.message.colorize(:red)
  rescue ex
    abort "caught #{ex.class} exception: #{ex.message}".colorize(:red)
  end
end
