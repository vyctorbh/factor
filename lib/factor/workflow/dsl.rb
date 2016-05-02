require 'factor/workflow/connector_future'

module Factor
  module Workflow
    class DSL
      def initialize(options={})
        @logger = options[:logger]
      end

      def run(address, options={})

        connector_class = Factor::Connector.get(address)
        connector = connector_class.new(options)

        Factor::Workflow::ConnectorFuture.new(connector)
      end

      def all(*events, &block)
        Future.all(*events, &block)
      end

      def any(*events, &block)
        Future.any(*events, &block)
      end

      def debug(message)
        log(:debug, message)
      end

      def info(message)
        log(:info, message)
      end

      def warn(message)
        log(:warn, message)
      end

      def error(message)
        log(:error, message)
      end

      def success(message)
        log(:success, message)
      end

      def log(type, message)
        @logger.log(type, message) if @logger
      end

      def on(type, *actions, &block)
        raise ArgumentError, "All actions must be an ConnectorFuture" unless actions.all? {|a| a.is_a?(ConnectorFuture) }
        actions.each {|a| a.on(type, &block) }
      end
      
    end

  end
end