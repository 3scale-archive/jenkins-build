module Jenkins
  module Build
    class Hub

      def available?
        system('which', 'hub', out: '/dev/null')
      end

      def ci_status(sha: nil)
        status, build_url = CiStatus.parse self.class.execute(sha)
        CiStatus.new(status, build_url)
      end

      def self.execute(commit)
        `hub ci-status -v #{commit}`
      end

      class CiStatus < Struct.new(:status, :build)
        MATCHER = %r{^(?<status>[^:]+): (?<build_url>https?://.+)$}.freeze


        def self.parse(output)
          hub = output.match(MATCHER) or return

          build = Jenkins::Build::Build.new(hub[:build_url])
          [ hub[:status], build ]
        end
      end
    end

  end
end
