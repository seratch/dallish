# -*- encoding: utf-8 -*-

require 'dalli'
require 'dallish/client'

module Dallish

  def self.new(params_or_dalli_servers = {}, dalli_options = {})
    if is_the_arg_dalli_servers(params_or_dalli_servers)
      params = {:servers => params_or_dalli_servers, :dalli_options => dalli_options}
    else
      params = params_or_dalli_servers
    end
    Dallish::Client.new(params)
  end

  private

  def self.is_the_arg_dalli_servers(params_or_dalli_servers)
    params_or_dalli_servers and
        (params_or_dalli_servers.is_a?(String) or
            params_or_dalli_servers.is_a?(Array))
  end

end
