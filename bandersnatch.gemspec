# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bandersnatch}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stefan Kaes", "Pascal Friederich"]
  s.date = %q{2010-01-28}
  s.default_executable = %q{start_rabbits}
  s.description = %q{A high available/reliabile messaging infrastructure}
  s.email = %q{developers@xing.com}
  s.executables = ["start_rabbits"]
  s.files = [
    ".gitignore",
     "Rakefile",
     "bandersnatch.gemspec",
     "bin/start_rabbits",
     "lib/bandersnatch.rb",
     "lib/bandersnatch/base.rb",
     "lib/bandersnatch/client.rb",
     "lib/bandersnatch/configuration.rb",
     "lib/bandersnatch/message.rb",
     "lib/bandersnatch/publisher.rb",
     "lib/bandersnatch/subscriber.rb",
     "test/bandersnatch.yml",
     "test/bandersnatch/base_test.rb",
     "test/bandersnatch/client_test.rb",
     "test/bandersnatch/configuration_test.rb",
     "test/bandersnatch/message_test.rb",
     "test/bandersnatch/publisher_test.rb",
     "test/bandersnatch/subscriber_test.rb",
     "test/bandersnatch_test.rb",
     "test/test_helper.rb"
  ]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Messages :P}
  s.test_files = [
    "test/bandersnatch/base_test.rb",
     "test/bandersnatch/client_test.rb",
     "test/bandersnatch/configuration_test.rb",
     "test/bandersnatch/message_test.rb",
     "test/bandersnatch/publisher_test.rb",
     "test/bandersnatch/subscriber_test.rb",
     "test/bandersnatch_test.rb",
     "test/test_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<uuid4r>, [">= 0.1.1"])
      s.add_runtime_dependency(%q<bunny>, [">= 0.6.0"])
      s.add_runtime_dependency(%q<redis>, [">= 0.1.2"])
      s.add_runtime_dependency(%q<amqp>, [">= 0.6.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<uuid4r>, [">= 0.1.1"])
      s.add_dependency(%q<bunny>, [">= 0.6.0"])
      s.add_dependency(%q<redis>, [">= 0.1.2"])
      s.add_dependency(%q<amqp>, [">= 0.6.6"])
      s.add_dependency(%q<activesupport>, [">= 2.3.4"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<uuid4r>, [">= 0.1.1"])
    s.add_dependency(%q<bunny>, [">= 0.6.0"])
    s.add_dependency(%q<redis>, [">= 0.1.2"])
    s.add_dependency(%q<amqp>, [">= 0.6.6"])
    s.add_dependency(%q<activesupport>, [">= 2.3.4"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end

