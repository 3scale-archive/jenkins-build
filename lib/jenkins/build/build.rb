require 'uri'

module Jenkins
  module Build
    class Build
      BUILDS = %w[lastBuild lastStableBuild lastSuccessfulBuild lastFailedBuild lastUnstableBuild lastUnsuccessfulBuild lastCompletedBuild].freeze
      JENKINS_PATH = %r{^/jobs?/(?<job>[\w-]+)/(?<build_number>\d+|#{Regexp.union(BUILDS)})}.freeze
      NUMBER = /\A\d+\z/.freeze

      attr_reader :uri, :job, :number

      def initialize(url)
        @uri = URI(url)

        match = @uri.path.match(JENKINS_PATH) or return

        @job = match[:job]
        @number = (number = match[:build_number]) =~ NUMBER ? number.to_i : number
      end
    end
  end
end
