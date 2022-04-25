#!/usr/bin/env rake
# frozen_string_literal: true

require_relative 'lib/ons-firestore/version'

task default: :build

desc 'Build the gem'
task :build do
  system('gem build ons-firestore.gemspec')
end

desc 'Push the gem to rubygems.org'
task release: [:build] do
  system("gem push ons-firestore-#{ONSFirestore::VERSION}.gem")
end
