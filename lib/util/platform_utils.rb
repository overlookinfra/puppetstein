require_relative 'git_utils.rb'
require_relative 'log_utils.rb'
require "net/http"

include Puppetstein::GitUtils
include Puppetstein::LogUtils

#! /usr/env/ruby
module Puppetstein
  module PlatformUtils
    def execute(command)
      IO.popen(command) do |io|
        while (line=io.gets) do
          puts line
        end
      end
    end

    def save_puppet_agent_artifact(host, tmp)
      desc = `git --git-dir=#{tmp}/puppet-agent/.git describe`
      desc = desc.gsub('-', '.').chomp
      # This assumes there is only one package for a given SHA.
      # If we ever support building more than one agent at a time,
      # this will need to be updated.
      path = Dir.glob("#{tmp}/puppet-agent/output/**/*#{desc}*")[0]
      package = path[/puppet-agent-#{desc}.*/]

      execute("mv #{path} #{tmp}")
      "#{tmp}/#{package}"
    end
  end
end
