# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_opengraph/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_opengraph"
  s.version     = ActsAsOpengraph::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ruben Ascencio"]
  s.email       = ["galateaweb@gmail.com"]
  s.homepage    = "https://github.com/rubenrails/acts_as_opengraph"
  s.summary     = %q{ActiveRecord extension that turns your models into graph objects}
  s.description = %q{ActiveRecord extension that turns your models into graph objects. Includes helper methods for adding <meta> tags and the Like Button to your views.}

  s.rubyforge_project = "acts_as_opengraph"
  
  s.add_development_dependency('sqlite3')
  s.add_development_dependency('rails')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
