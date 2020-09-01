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

  describe 'correction' do
    it 'replaces camel case with snake case' do
      expect_offense(<<~RUBY)
        obj.getPaid(1, :getPaid)
        ^^^^^^^^^^^^^^^^^^^^^^^^ Use snake_case method names when referencing Java code. Replace `#getPaid` with `#get_paid`
      RUBY

      expect_correction(<<~RUBY)
        obj.get_paid(1, :getPaid)
      RUBY
    end
  end

  describe 'IgnoredPatterns for method names' do
    let(:cop_config) do
      {
        'IgnoredPatterns' => [
          'Types'
        ]
      }
    end

    let(:config) { RuboCop::Config.new('JRuby/SnakeCaseMethods' => cop_config) }

    it 'does not register an offense' do
      expect_no_offenses(<<~RUBY)
        include Dry.Types(default: :nominal)
      RUBY
    end
  end
end
