require 'thor'

module Jenkins
  module Build
    class CLI < Thor

      extend Jenkins::Build::Git

      desc "configure", "configures this project"
      option :project, desc: 'Jenkins project name', required: true
      option :server, desc: 'Jenkins server', required: true
      option :user, desc: 'Your User', required: true
      option :api_key, desc: 'API Key (http://<server>/user/<user>/configure)', required: true

      def configure
        configuration.merge!(options)

        configuration.write
      end

      option :branch, desc: 'Git branch', default: current_branch
      desc 'trigger', 'triggers build of a branch'
      def trigger
        unless configuration.exists?
          warn "must run: 'jenkins-build configure' first"
          exit(1)
        end

        client.trigger(branch)
        puts "Triggered build of #{configuration.project} with branch #{branch}."
      end

      option :branch, desc: 'Git branch', default: current_branch
      desc 'status', 'prints status of a branch'
      def status
        unless system('which', 'hub')
          warn 'install `hub` tool to get ci status (https://github.com/github/hub)'
          exit 1
        end
        exec('hub', 'ci-status', branch, '-v')
      end

      private

      def branch
        options[:branch]
      end

      def client
        @client ||= Jenkins::Build::Client.new(configuration)
      end

      def configuration
        @configuration ||= Jenkins::Build::Configuration.new(Dir.pwd)
      end
    end
  end
end
