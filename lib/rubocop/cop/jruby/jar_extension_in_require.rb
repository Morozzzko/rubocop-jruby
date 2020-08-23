# frozen_string_literal: true

# TODO: when finished, run `rake generate_cops_documentation` to update the docs
module RuboCop
  module Cop
    module JRuby
      # TODO: Write cop description and example of bad / good code. For every
      # `SupportedStyle` and unique configuration, there needs to be examples.
      # Examples must have valid Ruby syntax. Do not use upticks.
      #
      # @example Enabled: true (default)
      #   # Description of the `bar` style.
      #
      #   # bad
      #   require 'something.jar'
      #
      #   # bad
      #   require_relative 'something-1.7.jar'
      #
      #   # good
      #   require 'something-1.7'
      #
      #   # good
      #   require_relative 'it_is_a_library'
      #
      class JarExtensionInRequire < Base
        extend AutoCorrector
        # TODO: Implement the cop in here.
        #
        # In many cases, you can use a node matcher for matching node pattern.
        # See https://github.com/rubocop-hq/rubocop-ast/blob/master/lib/rubocop/node_pattern.rb
        #
        # For example
        MSG = 'Explicit .jar extension is discouraged. Replace it with %<method_name>s %<replacement_path>s'

        def ends_with_jar?(node)
          node.end_with?('.jar')
        end

        def_node_matcher :require_with_jar?, <<~PATTERN
          (send _ ${:require :require_relative}
            $(str #ends_with_jar?))
        PATTERN

        def on_send(node)
          require_with_jar?(node) do |method_name, argument|
            fixed_argument = argument.source.gsub(/\.jar/, '')

            add_offense(node, message: format(MSG, method_name: method_name.to_s, replacement_path: fixed_argument)) do |corrector|
              corrector.replace(argument, fixed_argument)
            end
          end
        end
      end
    end
  end
end
