module Jenkins
  module Build
    module Git
      def current_branch
        `git symbolic-ref --short HEAD`.strip
      end
    end
  end
end
