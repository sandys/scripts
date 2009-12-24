require 'rake'
require 'rake/testtask'
require 'test/unit'

namespace :sss do
   task :test do 
    files = FileList['testdir/*.rb']
    files.each do |file|
        print "starting #{file} \n"
        Rake::TestTask.new(:selenium) do |t|
            t.libs << "test"
            t.test_files = file
            t.verbose = true
          end 
        begin
        task(:selenium).execute
            rescue;
        end   
    end
   end


## - this is useless. All the files are merged into a single task: this means if 
## one task fails, then everything fails.
## we need on the fly generation of tasks based on files
## inspired from 
## http://toolmantim.com/articles/creating_rake_testtasks_on_the_fly
#    Rake::TestTask.new(:selenium) do |t|
#        t.libs << "test"
#        t.test_files = FileList['tmp/*.rb']
#        t.verbose = true
#      end

end 
