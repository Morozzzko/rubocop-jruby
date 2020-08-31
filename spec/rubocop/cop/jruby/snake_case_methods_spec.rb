# frozen_string_literal: true

RSpec.describe RuboCop::Cop::JRuby::SnakeCaseMethods do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense with call on self' do
    expect_offense(<<~RUBY)
      getPaid
      ^^^^^^^ Use snake_case method names when referencing Java code. Replace `#getPaid` with `#get_paid`
    RUBY
  end

  it 'registers an offense with call on an object' do
    expect_offense(<<~RUBY)
      obj.getPaid
      ^^^^^^^^^^^ Use snake_case method names when referencing Java code. Replace `#getPaid` with `#get_paid`
    RUBY
  end

  it 'registers an offense with arguments' do
    expect_offense(<<~RUBY)
      obj.getPaid(1, 2)
      ^^^^^^^^^^^^^^^^^ Use snake_case method names when referencing Java code. Replace `#getPaid` with `#get_paid`
    RUBY
  end

  it 'does not register an offense on snake_case methods' do
    expect_no_offenses(<<~RUBY)
      obj.get_paid
    RUBY
  end

  describe 'exceptions' do
    let(:config) { RuboCop::Config.new }

    it 'does not register an offense on an exception' do
      pending 'Not implemented yet'

      expect_no_offenses(<<~RUBY)
        Dry.Types
      RUBY
    end
  end
end
