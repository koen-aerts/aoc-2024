package main

import (
  "fmt"
  "regexp"
  "strconv"
  "bufio"
  "os"
)

func main() {
  file, _ := os.Open("codes.txt")
  scanner := bufio.NewScanner(file)
  var sum int = 0
  re, _ := regexp.Compile("[^0-9]*")
  for scanner.Scan() {
    var calNum = re.ReplaceAllString(scanner.Text(), "")
    var calCode = calNum[0:1] + calNum[len(calNum)-1:]
    calInt, _ := strconv.Atoi(calCode)
    fmt.Println("  Value: ", calInt)
    sum += calInt
  }
  fmt.Println("Sum: ", sum)
}
