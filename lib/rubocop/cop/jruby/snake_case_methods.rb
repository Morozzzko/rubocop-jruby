# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module JRuby
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @example EnforcedStyle: bar (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   bad_bar_method
      #
      #   # bad
      #   bad_bar_method(args)
      #
      #   # good
      #   good_bar_method
      #
      #   # good
      #   good_bar_method(args)
      #
      # @example EnforcedStyle: foo
      #   # Description of the `foo` style.
      #
      #   # bad
      #   bad_foo_method
      #
      #   # bad
      #   bad_foo_method(args)
      #
      #   # good
      #   good_foo_method
      #
      #   # good
      #   good_foo_method(args)
      #
      class SnakeCaseMethods < Base
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop-ast/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Use snake_case method names when referencing Java code. Replace `#%<method_name>s` with `#%<suggested_method_name>s`'

        def camel_case?(node)
          node.to_s.match?(/[A-Z]/)
        end

        def_node_matcher :bad_method?, <<~PATTERN
          (send _ $#camel_case? ...)
        PATTERN

        def on_send(node)
          bad_method?(node) do |method_name|
            add_offense(
              node,
              message: format(
                MSG,
                method_name: method_name,
                suggested_method_name: underscore(method_name.to_s)
              )
            )
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
