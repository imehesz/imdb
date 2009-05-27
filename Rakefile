require 'rubygems'
require 'spec/rake/spectask'

desc "Default: run specs"
task :default => 'spec:run'

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList["spec/**/*_spec.rb"]
end

