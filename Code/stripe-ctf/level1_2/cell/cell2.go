package main

import (
    "os/exec"
    "os"
    "fmt"
    "log"
    "bytes"
    "time"
    "crypto/sha1"
    "io"
    "github.com/yosssi/gocmd"

)

var IsDebug bool = true 
var Log *log.Logger 

func reset() {
  out,_ :=  exec.Command("git", "fetch", "origin").Output()
  Log.Printf("write1 = %s", out)
  out,_ =  exec.Command("git", "reset" ,"--hard", "origin/master").Output()
  Log.Printf("write1 = %s", out)

}

func create_ledger() {
  Log.Println("in ledger")
  f, err1:= os.OpenFile("LEDGER.txt", os.O_APPEND|os.O_WRONLY, 0666) 
  Log.Println("err1 = ", err1, "and")
  _,err := f.WriteString("user-2aqm3dv4: 1") 
  Log.Println("err = ", err)
  _,_ =  exec.Command("git", "add" ,"LEDGER.txt").Output()
  f.Close() 
}

func starter()([]byte,[]byte,[]byte,int32){
  reset()
  create_ledger()
  cur_tree_hash,_ :=  exec.Command("git", "write-tree").Output()
  curr_diff,_ :=  exec.Command("cat", "difficulty.txt").Output()
  parent,_ :=  exec.Command("git", "rev-parse", "HEAD").Output()
  //timestamp := time.Now().Format("20060102150405")
  timestamp := int32(time.Now().Unix())
  Log.Println("timestamp = ", timestamp)
  return cur_tree_hash, curr_diff, parent, timestamp

  
}

var seed string = "aaaa343"
var STRING int = 1
func solve() {
  
  cur_tree_hash, /*curr_diff*/_, parent, timestamp := starter()
  counter := 1 
  for i:=1;i<2;i=i+1 {
   counter += 1 
   if counter%300000 == 0{
      exec.Command("git", "fetch", "origin").Run()
      rev_parse_origin,_ :=  exec.Command("git", "rev-parse", "origin/master").Output()
      rev_parse_head,_ :=  exec.Command("git", "rev-parse", "HEAD").Output()
      Log.Println("origin = ", string(rev_parse_origin), " head = ", string(rev_parse_head))
      if bytes.Compare(rev_parse_origin,rev_parse_head) !=0 {
        //break
        starter()
      }
   }

    body := fmt.Sprintf("tree %s\n parent %s\n author CTF user <me@example.com> %d +0000\n committer CTF user <me@example.com> %d +0000\n\nGive me a Gitcoin\n\n%d",string(cur_tree_hash), string(parent), timestamp, timestamp, counter)
    h := sha1.New()
	  io.WriteString(h, body + "\n")
	  sha2 := h.Sum(nil)
    //sha1,_ := exec.Command("bash", "-c","echo",body," | git hash-object -t commit  --stdin").Output()
    sha11,err := gocmd.Pipe(exec.Command("echo", body), exec.Command("git", "hash-object", "-t", "commit", "--stdin"))
    //sha11,err := gocmd.Pipe(exec.Command("bash", "-c", "echo", body))
    //sha1,_ := exec.Command("bash", "-c","echo",body," | git hash-object -t commit  --stdin").Output()

    //fmt.Println("sha2=",string(sha2), " git = ", string(sha11))
    fmt.Printf("gen=%x, git=%s err %s body \n",sha2, sha11, err)
  }
}


func main() {
        if IsDebug {
	      	Log = log.New(os.Stderr, "", log.LstdFlags)
      	}else {
		      Log = log.New(bytes.NewBuffer([]byte{}), "", log.LstdFlags)
	      }

        //reset()
        solve()
        //create_ledger()
        cmd := exec.Command("ls")
        //stdout, _ := cmd.StdoutPipe()
        fmt.Println("heloooo")
        /*if err != nil {
            fmt.Println("Trouble with e's stdout")
            fmt.Println(err)
        }
        stderr, err := cmd.StderrPipe()
        if err != nil {
            fmt.Println("Trouble with e's stderr")
            fmt.Println(err)
        }
        err = cmd.Start()
        if err != nil {
            fmt.Println(err)
        }*/
        //io.Copy(os.Stdout, cmd.StdoutPipe().stdout) 
        //io.Copy(os.Stderr, stderr) 
        //cmd.Wait()
        cmd.Start()
        stdout,_ := exec.Command("date").Output()
        fmt.Printf("%s",stdout)
}

