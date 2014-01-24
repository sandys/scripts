#require time
=begin
#create new repo
%x(git clone  lvl1-nmvgcxcn@stripe-ctf.com:level1 test1 )
%x(cd test1)
result = %x(git write-tree)
puts result
=end

require 'digest/sha1'
require 'celluloid/autostart'
require 'timers'

$cur_tree_hash = %x(git write-tree)
$curr_diff = %x(cat difficulty.txt)
$parent=%x(git rev-parse HEAD)
$timestamp = Time.now.to_i

class Git
  include Celluloid
  
  def initialize(g=nil)
    @g = g
  end


def init_workers()
@solvers = []
@solvers << Solve.new(1)
##s2 = Solve.new.async.solve(64000000)
#Celluloid.stack_dump
##s2 = Solve.new.async.solve(82000)
@solvers << Solve.new("adbac873f3")
@solvers << Solve.new("8735889f3")
@solvers << Solve.new("f82cb2442")
@solvers << Solve.new("0febb8aad")
#s4 = Solve.new.async.solve("869d79ea9f82c",g)
#s5 = Solve.new.async.solve("8735889f3",g)
#s6 = Solve.new.async.solve("f82cb2442",g)
#s7 = Solve.new.async.solve("0febb8aad",g)
#s8 = Solve.new.async.solve("dacdf19a0",g)

@solvers.map {|s| s.async.solve(0,Actor.current)}

end

def kill_workers()
  @solvers.map {|s| s.async.terminate()}
end

def check
    timers = Timers.new
    puts "hiiiiiiiiii"
    init_workers()
    timers.every(1) do 
      %x(git fetch origin >/dev/null 2>/dev/null)
      #if %x(git describe --always --abbrev=16) != %x(git ls-remote origin 'refs/heads/master' |cut  -c1-16)
      if %x(git rev-parse origin/master) != %x(git rev-parse HEAD)
        puts "Thread check...."
        kill_workers()
        initialize2()
	puts " #{$cur_tree_hash} - #{$parent} - #{$timestamp}"
        init_workers()
      end 
    end
    loop { timers.wait }

  
end


def write_repo(body, sha2, origin=false)
    if origin
        puts "resetting repo to origin" 
        %x(git fetch origin >/dev/null 2>/dev/null)
  	%x(git reset --hard origin/master >/dev/null)
    else
    puts "winning #{sha2} body = " +body 
    #puts sha2 
    %x[bash -c 'git hash-object -t commit -w --stdin <<< \"#{body}\"']
    #puts sha1
    puts %x[git reset --hard "#{sha2}"]
    puts %x[git push origin master ] 

  
    end
 end


def reset
end


def create_ledger
  File.open("LEDGER.txt", 'a') do |file|
    file.write "user-2aqm3dv4: 1"
  end

  %x(git add LEDGER.txt)

end




def initialize2
        puts "--------------- REINITIALIZING --------------"
reset()
@g.write_repo(nil,nil, true)
create_ledger()
$cur_tree_hash = %x(git write-tree)
$curr_diff = %x(cat difficulty.txt)
$parent=%x(git rev-parse HEAD)
$timestamp = Time.now.to_i

        puts "--------------- DONE REINITIALIZING --------------"
return $cur_tree_hash, $curr_diff, $parent, $timestamp

end

end




class Solve
  include Celluloid

def initialize(seed)
 @seed = seed
 @prebody = body = "tree #{$cur_tree_hash}
parent #{$parent}
author CTF user <me@example.com> #{$timestamp} +0000
committer CTF user <me@example.com> #{$timestamp} +0000

Give me a Gitcoin
" 
end

def solve2
timers = Timers.new
   puts "hiiiiiiiiii"
   timers.every(1) { puts "Another 5 seconds" }
   loop { timers.wait }

end

MIL = 1000000

def solve(seed, g)
  
#cur_tree_hash, curr_diff, parent, timestamp = initialize2()
  puts "Starting solve................"

counter = @seed 
time_start = Time.now.utc.to_i
while 1 do 
  #puts "Starting solve 2................"
  counter =counter.next


  body = @prebody + "\n#{counter}"

  #puts body
  modified_body = body + "\n"
  #sha1=%x[bash -c 'git hash-object -t commit --stdin <<< \"#{body}\"']
  sha2=Digest::SHA1.hexdigest ("commit #{modified_body.length}\0" + modified_body)
	 
	 if counter%MIL == 0
	 time_delta = Time.now.utc.to_i - time_start
         hash_rate = MIL/time_delta
	  puts " sha2 " + sha2 + " rate = #{hash_rate}" 
	  time_start = Time.now.utc.to_i
	end 
  if sha2 <= $curr_diff
   puts "WIN - #{sha2}"
    g.write_repo(body,sha2)        
    #break
    counter=@seed
  end

end


end
end

#reset()
#create_ledger()

g = Git.new
g1 = Git.new(g).async.check
sleep




