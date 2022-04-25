# frozen_string_literal: true

require 'date'

require_relative 'lib/ons-firestore/version'

Gem::Specification.new do |s|
  s.name                  = 'ons-firestore'
  s.version               = ONSFirestore::VERSION
  s.date                  = Date.today.to_s
  s.summary               = 'Opinionated Google Firestore abstraction.'
  s.description           = <<~DESC
    An opionated abstraction for reading and writing Google Firestore documents.
  DESC
  s.authors               = ['John Topley']
  s.email                 = ['john.topley@ons.gov.uk']
  s.files                 = ['README.md']
  s.files                += Dir['lib/**/*.rb']
  s.homepage              = 'https://github.com/ONSdigital/ons-firestore'
  s.license               = 'MIT'
  s.required_ruby_version = '>= 3.0.0'

  s.add_runtime_dependency 'google-cloud-firestore', '~> 2.6'
  s.add_development_dependency 'bundler', '~> 2.3'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'rubocop', '~> 1.17'
end
