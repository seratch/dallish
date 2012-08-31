# -*- encoding: utf-8 -*-

require 'logger'
require 'dalli'
require 'net/telnet'

module Dallish
  class Client

    attr_accessor :servers, :log, :dalli

    def initialize(params)
      raise ArgumentError.new('`params` should be a Hash value.') unless params.is_a? Hash

      # log settings
      @log = Logger.new(params[:log_output] || STDOUT)
      @log.level = params[:log_level] || Logger::INFO

      # memcached server settings
      if params[:servers] and params[:servers].is_a?(String)
        @servers = [params[:servers]]
      else
        @servers = params[:servers] || ['127.0.0.1:11211']
      end
      @dalli_options = params[:options] || {}
      @dalli = Dalli::Client.new(@servers, @dalli_options)

      # cannot support memcached 1.6 or higher
      self.servers.each { |server|
        version = telnet(server, :prompt => /\n/).cmd('version')
        self.log.debug "version: #{version}"

        /VERSION (?<major_version>\d+\.\d+).*/ =~ version
        if major_version and major_version.to_f >= 1.6
          raise ArgumentError.new("Sorry, Dallish doesn't support memcached 1.6 or higher version.")
        end
      }
    end

    def telnet(server, options = {})
      (host, port) = server.split(':')
      self.log.debug "target memcahced server: #{host}:#{port}"
      telnet = Net::Telnet::new(
          'Host' => host,
          'Port' => port,
          'Prompt' => options[:prompt] || /(^END$)/,
          'Timeout' => options[:timeout] || 3
      )
    end

    def all_keys()
      self.servers.flat_map { |server|
        telnet = telnet(server)
        begin
          slab_ids = telnet.cmd("stats slabs").split("\n").map { |line|
            /STAT (?<slab_id>\d+):.+/ =~ line
            slab_id
          }.reject { |e| e.nil? }.uniq

          slab_ids.flat_map { |slab_id|
            telnet.cmd("stats cachedump #{slab_id} 1000000").split("\n").map { |line|
              /ITEM (?<key>.+) \[\d+ b; \d+ s\]/ =~ line
              key
            }
          }
        rescue Exception => e
          self.log.info "Failed to get keys because #{e.to_s}"
          []
        ensure
          telnet.close()
        end
      }.reject { |e| e.nil? }.uniq
    end

    def find_keys_by(regexp)
      all_keys.select { |key|
        if key.is_a?(Array) then
          puts "#{key},#{key.class}"
        end
        regexp.match(key) }
    end

    def delete_all_by(regexp)
      find_keys_by(regexp).each do |key|
        self.dalli.delete(key)
      end
    end

    def find_all_by(regexp)
      find_keys_by(regexp).inject({}) { |result, key|
        result[key] = self.dalli.get(key)
        result
      }
    end

    def method_missing(name, *args, &block)
      self.dalli.send(name, *args, &block)
    end

  end
end
