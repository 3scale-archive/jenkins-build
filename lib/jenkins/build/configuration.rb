require 'pathname'
require 'yaml/store'

module Jenkins
  module Build
    class Configuration

      CONFIG = Pathname('.jenkins-build').freeze

      CONFIG_KEYS = [:server, :project, :api_key, :user]

      def initialize(folder)
        @config = Pathname(CONFIG).expand_path(folder).freeze
        @store = YAML::Store.new(@config)
      end

      CONFIG_KEYS.each do |key|
        define_method(key) do
          options.fetch(key)
        end
      end

      def exists?
        @config.exist?
      end

      def merge!(opts)
        CONFIG_KEYS.each do |key|
          options[key] = opts[key]
        end
      end

      def options
        @options ||= read
      end

      def read
        @store.transaction(true) do
          @options = CONFIG_KEYS.map do |key|
            [ key, @store[key] ]
          end.to_h
        end
      end

      def write(options = @options)
        @store.transaction do
          CONFIG_KEYS.each do |key|
            @store[key] = options.fetch(key)
          end
        end
      end
    end
  end
end
