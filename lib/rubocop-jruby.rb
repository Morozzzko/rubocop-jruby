# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/jruby'
require_relative 'rubocop/jruby/version'
require_relative 'rubocop/jruby/inject'

RuboCop::JRuby::Inject.defaults!

require_relative 'rubocop/cop/jruby_cops'
