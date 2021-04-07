require "./spec_helper"
require "uri"
require "../src/cli"

# Mock the HTTP::Client.post method we'll be calling later. I couldn't
# find a mocking library that worked for me, so we do it in a more
# down to earth fasion. This wont scale, but suffice for this simple tool.
def HTTP::Client.post(uri : URI, form : Hash)
  uri.to_s.should eq "https://botmail:api-key@hostname/api/v1/messages"
  form.should eq Hash{
    "type"    => "stream",
    "to"      => "streamname",
    "topic"   => "topic",
    "content" => "the message",
  }

  yield HTTP::Client::Response.new(200)
end

describe Tozulip::Cli do
  describe "argument handling" do
    it "requires a bot email" do
      expect_raises(Tozulip::Abort, "No bot email given") do
        Tozulip::Cli.run("-k api-key -H hostname -s streamname -t topic".split)
      end
    end

    it "requires an API key" do
      expect_raises(Tozulip::Abort, "No API key given") do
        Tozulip::Cli.run("-m botmail -H hostname -s streamname -t topic".split)
      end
    end

    it "requires a host" do
      expect_raises(Tozulip::Abort, "No Zulip hostname given") do
        Tozulip::Cli.run("-m botmail -k api-key -s streamname -t topic".split)
      end
    end

    it "requires a stream name" do
      expect_raises(Tozulip::Abort, "No stream given") do
        Tozulip::Cli.run("-m botmail -k api-key -H hostname -t topic".split)
      end
    end

    it "requires a topic" do
      expect_raises(Tozulip::Abort, "No topic given") do
        Tozulip::Cli.run("-m botmail -k api-key -H hostname -s streamname".split)
      end
    end

    it "requires a message to send" do
      expect_raises(Tozulip::Abort, "Please supply message to send as argument") do
        Tozulip::Cli.run("-m botmail -k api-key -H hostname -s streamname -t topic".split)
      end
    end
  end

  it "makes the right request to Zulip server" do
    Tozulip::Cli.run("-m botmail -k api-key -H hostname -s streamname -t topic the message".split)
  end
end
