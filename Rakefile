require "rake/clean"
require "spec/rake/spectask"

CLOBBER.include "lib/orange/grammar.rb"

desc "Compile grammar"
task :tt do
  sh "tt lib/orange/grammar.tt"
end

task :default => :spec

Spec::Rake::SpecTask.new do |t|
  t.spec_opts = %w(-fs -c)
  t.spec_files = FileList["spec/**_spec.rb"]
end
