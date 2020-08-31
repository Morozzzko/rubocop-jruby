# frozen_string_literal: true

module RuboCop
  module Cop
    module JRuby
      # This cop enforces that all methods are in snake_case
      # It actually overlaps in functionality with Style/MethodName, hence it is disabled by default
      # Yet, it was written explicitly for easier refactoring and _automatic rewrite_
      # If you use it with rubocop -A, it'll automatically update your code.
      # It will simplify refactoring
      #
      # @example Enabled: true
      #   # bad
      #   getName
      #
      #   # bad
      #   getName(args)
      #
      #   # good
      #   get_name
      #
      #   # good
      #   get_name(args)
      #
      class SnakeCaseMethods < Base
        extend AutoCorrector
        include IgnoredPattern

        MSG = 'Use snake_case method names when referencing Java code. Replace `#%<method_name>s` with `#%<suggested_method_name>s`'

        def camel_case?(node)
          node.to_s.match?(/[A-Z]/)
        end

        def_node_matcher :bad_method?, <<~PATTERN
          (send _ $#camel_case? ...)
        PATTERN

        def on_send(node)
          bad_method?(node) do |method_name|
            suggested_method_name = underscore(method_name.to_s)

            return if matches_ignored_pattern?(method_name)

            message = format(
              MSG,
              method_name: method_name,
              suggested_method_name: suggested_method_name
            )

            add_offense(node, message: message) do |corrector|
              corrector.replace(node.loc.selector, suggested_method_name)
            end
          end
        end

        private

        def underscore(string)
          string.gsub(/::/, '/')
                .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
                .gsub(/([a-z\d])([A-Z])/, '\1_\2')
                .tr('-', '_')
                .downcase
        end
      end
    end
  end
end
