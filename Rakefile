require 'rake/testtask'

# To run one test: rake test TEST=just_one_file.rb
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.libs << 'test'
end

def built_gem_name
  Dir.glob('erb_parser-*.*.*.gem').first
end

task :build do
  `rm *.gem`
  puts `gem build erb_parser.gemspec`
end

task :install do
  puts `gem install #{built_gem_name}`
end

task :release do
  puts `gem push #{built_gem_name}`
end