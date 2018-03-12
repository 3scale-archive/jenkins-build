module Jenkins
  module Build
    class TestReport
      def initialize(suites, cases)
        @suites = suites.freeze
        @cases = cases.freeze
      end

      def failures
        path = project_path
        failures = @cases.select(&:failure?)

        failures.map do |failure|
          failure.cause(path)
        end
      end

      def suites
        @suites
      end

      def project_path
        group = @cases.map(&:project_path).compact.reject{|p| Pathname(p).relative? }.group_by{ |path| path }.values.max_by(&:size) or return
        group.first
      end

      class Builder

        def build_report(report)
          suites, cases = report.delete('suites'.freeze).map(&method(:build_suite)).transpose

          TestReport.new(suites, cases.flatten)
        end

        def build_suite(suite)
          cases = suite.delete('cases'.freeze).map(&method(:build_case))
          [ Suite.new(suite, cases), cases ]
        end

        def build_case(test)
          status = Status.new(test.delete('status'.freeze))
          stack_trace = StackTrace.new(test.delete('errorStackTrace'))
          TestCase.new(test, status, stack_trace)
        end

      end

      protected

      class Suite
        def initialize(suite, cases)
          @suite = suite
          @cases = cases
        end
      end

      class TestCase
        attr_reader :status, :stack_trace

        def initialize(test, status, stack_trace)
          @test = test
          @status = status
          @stack_trace = stack_trace
        end

        def failure?
          status.failure?
        end

        ORA = Struct.new(:id, :message)

        def extract_ora(str)
          return unless str

          if (match = str.match(/(ORA-\d{5}): ([^:]+)/))
            ORA.new(match[1], match[2])
          end
        end

        def ora
          extract_ora(@test.fetch('errorDetails')) || extract_ora(stack_trace.stderr)
        end

        def cause(path)
          o = ora
          msg = stack_trace.cause(path)

          if ora
            msg = "#{msg},#{o.id},#{o.message.delete('"')}"
          else
            msg = "#{msg},,"
          end

          msg
        end

        def project_path
          path = stack_trace.root_path
          path.empty? ? nil : path
        end
      end

      class Status
        FAILURES = %w[FAILED REGRESSION]
        def initialize(status)
          @status = status
        end

        def failure?
          FAILURES.include?(@status)
        end

        def success?
          @status == 'PASSED'.freeze
        end
      end

      class StackTrace
        attr_reader :stack_trace, :stderr, :root_path

        def initialize(stderr)
          @stderr = stderr
          @stack_trace = stack_frames.reject(&method(:system_path?))
          @root_path = longest_common_substr(stack_trace) || ''
        end

        def cause(project_path = root_path)
          stack_trace.lazy.reverse_each.
            map { |path| relative_path(path, project_path || root_path) }.
            find(&method(:test_stack_frame?))
        end

        TEST_PATHS = %w[test spec features]

        def test_stack_frame?(project_frame)
          TEST_PATHS.any?(&project_frame.method(:start_with?))
        end

        def relative_path(full_frame, project_path)
          full_frame.sub(project_path, ''.freeze)
        end

        RUBY_STACK_FRAME = /((?:\.?\/)?[\w._-][\/\w._-]+\.rb:\d+)/.freeze
        CUCUMBER_STACK_FRAME = /(features\/[\w._-][\/\w._-]+:\d+)/.freeze

        def extract_stack_frames(text)
          text.scan(RUBY_STACK_FRAME) + text.scan(CUCUMBER_STACK_FRAME)
        end

        def stack_frames
          extract_stack_frames(stderr.to_s).flatten.compact
        end

        SYSTEM_PATHS = %w[/usr/lib /lib]

        def system_path?(path)
          SYSTEM_PATHS.any?(&path.method(:start_with?))
        end

        # http://stackoverflow.com/questions/2158313/finding-common-string-in-array-of-strings-ruby
        def longest_common_substr(strings)
          strings = strings.select {|str| Pathname(str).absolute? }
          return unless strings.length > 1
          shortest = strings.min_by(&:length) or return
          maxlen = shortest.length
          maxlen.downto(0) do |len|
            0.upto(maxlen - len) do |start|
              substr = shortest[start,len]
              return substr if strings.all?{|str| str.start_with?(substr) }
            end
          end

          nil
        end
      end

    end
  end
end
