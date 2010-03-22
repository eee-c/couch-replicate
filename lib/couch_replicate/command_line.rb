require 'optparse'
require 'pp'

module CouchReplicate
  class CommandLine
    def self.run(*args)
      CommandLine.new(*args).run
    end

    attr_reader :database, :hosts, :options

    def initialize(args)
      parse_options(args)
    end

    def run
      if @options[:link] || @options.empty?
        $stderr.puts "Linking replication hosts..."
        CouchReplicate.link(@database, @hosts)
      end
      if @options[:reverse]
        $stderr.puts "Reverse linking replication hosts..."
        CouchReplicate.reverse_link(@database, @hosts)
      end
      if @options[:n]
        $stderr.puts "Linking every #{@options[:n]}th replication hosts..."
        CouchReplicate.nth(@options[:n], @database, @hosts)
      end
    end

    def parse_options(args)
      @options = { }

      options_parser = OptionParser.new do |opts|
        opts.banner = "Usage: couch-replicate db [OPTIONS] couchdb_host_01, couchdb_host_02[, couchdb_host_03...]"

        opts.separator ""

        opts.on("-l", "--link", "link the hosts in a circular list (this is the default if no other options are specified)") do
          @options[:link] = true
        end

        opts.on("-r", "--reverse", "link the hosts in a cicular list, reversing the order supplied") do
          @options[:reverse] = true
        end

        opts.on("-n", "-number [LINK_EVERY=3]", "link every n hosts") do |n|
          @options[:n] = n.to_i > 0 ? n.to_i : 3
        end
      end

      begin
        options_parser.parse!(args)
        @database = args.shift
        @hosts = args
      rescue OptionParser::InvalidOption => e
        raise e
      end
     end
  end
end
