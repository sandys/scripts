import subprocess
#from hashlib import sha1
import hashlib

import time

def reset():
  subprocess.Popen('git fetch origin master >/dev/null 2>/dev/null', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
  subprocess.Popen('git reset --hard origin/master >/dev/null', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()

def create_ledger():
  with open("LEDGER.txt", "a") as myfile:
      myfile.write("user-2aqm3dv4: 1")
  subprocess.Popen('git add LEDGER.txt', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()

def STARTialize2():
  print "--------------- RESTARTIALIZING --------------"
  reset()
  create_ledger()
  cur_tree_hash = subprocess.Popen('git write-tree', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
  curr_diff = subprocess.Popen('cat difficulty.txt', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
  parent= subprocess.Popen('git rev-parse HEAD', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
  timestamp = int(time.time())
  #puts "curr hash = #{cur_tree_hash} parent=#{parent}"

  return cur_tree_hash, curr_diff, parent, timestamp


START = 1
def solve():

  cur_tree_hash, curr_diff, parent, timestamp = STARTialize2()
  counter = START
  while 1:
    counter += 1

    if counter%300000 == 0:
       local= subprocess.Popen('git describe --always --abbrev=16', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
       remote = subprocess.Popen('git ls-remote origin \'refs/heads/master\' |cut  -c1-16', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
       #print "local = #{local} remote = #{remote}"
       if local != remote:
          cur_tree_hash, curr_diff, parent, timestamp = STARTialize2()
          counter = START

    body = "tree %s\n parent %s\n author CTF user <me@example.com> %s +0000\n committer CTF user <me@example.com> %s +0000\n\nGive me a Gitcoin\n\n%s" % (cur_tree_hash, parent, timestamp, timestamp, counter)
    #body = "what is up, doc?"

    modified_body = body + "\n"
    #sha2=Digest::SHA1.hexdigest ("commit #{modified_body.length}\0" + modified_body)
    #h.update("commit %d\0%s"% (len(modified_body),modified_body))
    sha2 = hashlib.sha1("commit %d\0%s"% (len(modified_body),modified_body)).hexdigest()
    #sha1=%x[bash -c 'git hash-object -t commit -w --stdin <<< \"#{body}\"']
    #sha1= subprocess.Popen('git hash-object -t commit  --stdin <<< \"%s\"'%body, shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
    #sha1 =subprocess.check_output("echo \"%s\" | git hash-object -t commit  --stdin "%body, shell=True,executable='/bin/bash').strip()

    #print sha1 + " vs " + sha2
    if sha2 <= curr_diff:
      #if 1:
      #sha1=%x[bash -c 'git hash-object -t commit -w --stdin <<< \"#{body}\"']
      print "body = %s" % body
      print "sha1 = %s vs sha2=%s" % (sha2,sha2)
      sha1= subprocess.Popen('git hash-object -t commit -w --stdin <<< \"%s\"'%body, shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
      #puts sha1
      print "done commit with sha1= %s"%sha1
      #puts %x[git reset --hard "#{sha2}"]
      subprocess.Popen('git reset --hard %s'%sha2, shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()
      print "done reset"
      #puts %x[bash -c 'git push']
      subprocess.Popen('bash -c \'git push\'', shell=True,executable='/bin/bash',  stdout=subprocess.PIPE).stdout.read().strip()


      break




#reset()
#create_ledger()
solve()


