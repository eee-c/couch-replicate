require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "couch-replicate"
    gem.summary = %Q{Set-up automatic CouchDB replication between hosts}
    gem.description = %Q{Command line and ruby interface for linking a set of CouchDB hosts for automatic replication.  Includes three rudimentary replication schemes: cicular link, reverse cicular link and link to every nth host.}
    gem.email = "github@eeecooks.com"
    gem.homepage = "http://github.com/eee-c/couch-replicate"
    gem.authors = ["Chris Strom"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "rest-client", ">= 1.4.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "couch-replicate #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
