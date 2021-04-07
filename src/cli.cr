require "option_parser"
require "uri"
require "http/client"

module Tozulip
  VERSION = "0.1.0"

  # Exception raised for a clean exit.
  class Exit < Exception
  end

  # Exception raised in case of errors.
  class Abort < Exception
  end

  # The Tozulip command.
  class Cli
    def self.run(argv = ARGV, io = STDOUT)
      mail = ENV["TOZULIP_MAIL"]?
      api_key = ENV["TOZULIP_APIKEY"]?
      hostname = ENV["TOZULIP_HOST"]?
      stream = ENV["TOZULIP_STREAM"]?
      topic = ENV["TOZULIP_TOPIC"]?

      OptionParser.parse(argv) do |parser|
        parser.banner = "Usage: tozulip [options] [message to send]"
        parser.separator
        parser.on("-h", "--help", "Display help") { raise Exit.new(parser.to_s) }
        parser.on("-m MAIL", "--mail=MAIL", "Email of bot") { |arg| mail = arg }
        parser.on("-k KEY", "--api-key=KEY", "API key of bot") { |arg| api_key = arg }
        parser.on("-H HOST", "--host=HOST", "Hostname of Zulip server") { |arg| hostname = arg }
        parser.on("-s STREAM", "--stream=STREAM", "Stream to send message to") { |arg| stream = arg }
        parser.on("-t TOPIC", "--topic=TOPIC", "Topic of message") { |arg| topic = arg }

        parser.missing_option { |option_flag| raise Abort.new("Option #{option_flag} needs an argument") }
        parser.invalid_option { |option_flag| raise Abort.new("#{option_flag} is not a valid option") }
      end

      raise Abort.new("No bot email given") unless mail
      raise Abort.new("No API key given") unless api_key
      raise Abort.new("No Zulip hostname given") unless hostname
      raise Abort.new("No stream given") unless stream
      raise Abort.new("No topic given") unless topic

      raise Abort.new("Please supply message to send as argument") if argv.empty?

      uri = URI.new scheme: "https", host: hostname, path: "/api/v1/messages", user: mail, password: api_key

      data = {
        "type" => "stream",
        # The compiler can't quite figure out that these can't be nil
        # when we get here, so we help it out.
        "to"      => stream.as(String),
        "topic"   => topic.as(String),
        "content" => argv.join(" "),
      }

      HTTP::Client.post(uri, form: data) do |response|
        if !response.success?
          raise Abort.new("Unexpected response #{response.status_code} code \"#{response.status_message}\", body: #{response.body}")
        end
      end
    end
  end
end
