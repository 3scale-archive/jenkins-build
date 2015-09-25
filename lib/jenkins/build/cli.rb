require 'thor'

module Jenkins
  module Build
    class CLI < Thor

      extend Jenkins::Build::Git

      def self.configuration
        Jenkins::Build::Configuration
      end

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
      desc 'trigger PARAMS', 'triggers build of a branch'
      def trigger(*params)
        unless configuration.exists?
          warn "must run: 'jenkins-build configure' first"
          exit(1)
        end

        params_hash = params.map{|param| param.split('=') }.to_h
        client.trigger(branch, params_hash)
        puts "Triggered build of #{configuration.project} with branch #{branch} #{params.join(' ')}"
      end

      option :branch, desc: 'Git branch', default: current_branch
      desc 'status', 'prints status of a branch'
      def status
        ci_status = self.ci_status

        puts "#{ci_status.status}: #{ci_status.uri}"
      end

      option :branch, desc: 'Git branch', default: current_branch
      option :job, desc: 'Jenkins job', default: configuration.project
      option :build, desc: 'Jenkins build number', default: 'lastCompletedBuild'

      desc 'failures', 'prints failed tests and how to run them'
      def failures
        if options[:job] || options[:build]
          build = Jenkins::Build::Build.new(jenkins_job_url)
        else
          build = self.ci_status.build || Jenkins::Build::Build.new(jenkins_job_url)
        end

        report = client.test_report(number: build.number, project: build.job)

        failures = report.failures.compact

        puts failures
      end

      protected

      def ci_status
        hub.ci_status(sha: branch)
      end

      def hub
        hub = Hub.new

        unless hub.available?
          warn 'install `hub` tool to get ci status (https://github.com/github/hub)'
          exit 1
        end

        hub
      end

      def branch
        options[:branch]
      end

      def client
        @client ||= Jenkins::Build::Client.new(configuration)
      end

      def jenkins_job_url
        URI.join(configuration.server, ['jobs', options[:job], options[:build]].join('/'))
      end

      def configuration
        @configuration ||= self.class.configuration.current
      end
    end
  end
end
