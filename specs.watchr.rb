def run(cmd)
  puts cmd
  system cmd
end

def spec(file)
  if File.exists?(file)
    run "spec -O spec/spec.opts #{file}"
  else
    puts "#{file} doesn't exist!"
  end
end

def run_all_tests
  # see Rakefile for the definition of the test:all task
  run( "rake spec")
end

# --------------------------------------------------
# Watchr Rules
# --------------------------------------------------
watch( '^spec.*/.*_spec\.rb'   )    { |m| spec("%s"              % m[0] ) }              # watch all specs
watch( '^app/models/(.*)\.rb')      { |m| spec("spec/models/%s_spec.rb" % m[1]) }        # watch all models
watch( '^app/controllers/(.*)\.rb') { |m| spec("spec/controllers/%s_spec.rb" % m[1]) }   # watch all controllers
watch( '^app/helpers/(.*)\.rb')     { |m| spec("spec/helpers/%s_spec.rb" % m[1]) }       # watch all hlevel models
watch( '^lib/(.*)\.rb'         )    { |m| spec("spec/lib/%s_spec.rb" % m[1] ) }          # watch all in lib
watch( '^spec/spec_helper\.rb' )    { run_all_tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
# Ctrl-\
Signal.trap('QUIT') do
  puts " --- Running all tests ---\n\n"
  run_all_tests
end

Signal.trap('INT') {
#  FileUtils.rm_r $cache_dir
  abort("\n")
}
