# frozen_string_literal: true

require 'avm'
require 'avm/eac_ruby_base1'
require 'avm/git'
require 'eac_ruby_gem_support'
EacRubyUtils::Rspec.default_setup_create(File.expand_path('..', __dir__)).stub_avm_contexts
EacRubyUtils.require_sub(__FILE__)
