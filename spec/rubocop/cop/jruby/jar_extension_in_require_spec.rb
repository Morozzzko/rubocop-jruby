# frozen_string_literal: true

RSpec.describe RuboCop::Cop::JRuby::JarExtensionInRequire do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  describe 'Bad: providing .jar to Kernel.require' do
    it 'registers an offense without version number' do
      expect_offense(<<~RUBY)
        require 'something.jar'
        ^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require 'something'
      RUBY
    end

    it 'registers an offense with version number' do
      expect_offense(<<~RUBY)
        require 'something-1.4.jar'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require 'something-1.4'
      RUBY
    end
  end

  describe 'Bad: providing .jar to Kernel.require_relative' do
    it 'registers an offense without version number' do
      expect_offense(<<~RUBY)
        require_relative 'something.jar'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require_relative 'something'
      RUBY
    end

    it 'registers an offense with version number' do
      expect_offense(<<~RUBY)
        require_relative 'something-1.4.jar'
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require_relative 'something-1.4'
      RUBY
    end
  end

  context 'Good: avoiding extension with Kernel.require' do
    it 'is not an offense' do
      expect_no_offenses(<<~RUBY)
        require 'something'
      RUBY
    end

    it 'is not an offense even with a version number' do
      expect_no_offenses(<<~RUBY)
        require 'something-1.4'
      RUBY
    end
  end

  context 'Good: avoiding extension with Kernel.require_relative' do
    it 'is not an offense' do
      expect_no_offenses(<<~RUBY)
        require_relative 'something'
      RUBY
    end

    it 'is not an offense even with a version number' do
      expect_no_offenses(<<~RUBY)
        require_relative 'something-1.4'
      RUBY
    end
  end

  describe 'autocorrection' do
    context 'with Kernel.require_relative' do
      it 'registers an offense without version number' do
        expect_offense(<<~RUBY)
          require_relative 'something.jar'
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require_relative 'something'
        RUBY

        expect_correction(<<~RUBY)
          require_relative 'something'
        RUBY
      end
    end

    context 'with Kernel.require' do
      it 'registers an offense without version number' do
        expect_offense(<<~RUBY)
          require 'something.jar'
          ^^^^^^^^^^^^^^^^^^^^^^^ Explicit .jar extension is discouraged. Replace it with require 'something'
        RUBY

        expect_correction(<<~RUBY)
          require 'something'
        RUBY
      end
    end
  end
end
