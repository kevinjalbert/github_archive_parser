# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard :rspec, :version => 2, :notifications => false, :all_on_start => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/github_archive_parser/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
