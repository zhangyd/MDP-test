# -*- encoding: utf-8 -*-
# stub: digest-murmurhash 1.1.1 ruby lib
# stub: ext/digest/murmurhash/extconf.rb

Gem::Specification.new do |s|
  s.name = "digest-murmurhash".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["ksss".freeze]
  s.date = "2016-01-05"
  s.description = "digest-murmurhash is class collections of use algorithm MurmurHash desiged by Austin Appleby.".freeze
  s.email = ["co000ri@gmail.com".freeze]
  s.extensions = ["ext/digest/murmurhash/extconf.rb".freeze]
  s.files = ["ext/digest/murmurhash/extconf.rb".freeze]
  s.homepage = "https://github.com/ksss/digest-murmurhash".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "digest-murmurhash is class collections of use algorithm MurmurHash desiged by Austin Appleby.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
  end
end
