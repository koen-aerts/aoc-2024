package main

import (
  "fmt"
  "strconv"
  "strings"
  "bufio"
  "os"
)

func Text2Num(text string) string {
  var newLine string = ""
  for i, _ := range text {
    if (strings.HasPrefix(text[i:], "one")) {
      newLine += "1"
    } else if (strings.HasPrefix(text[i:], "two")) {
      newLine += "2"
    } else if (strings.HasPrefix(text[i:], "three")) {
      newLine += "3"
    } else if (strings.HasPrefix(text[i:], "four")) {
      newLine += "4"
    } else if (strings.HasPrefix(text[i:], "five")) {
      newLine += "5"
    } else if (strings.HasPrefix(text[i:], "six")) {
      newLine += "6"
    } else if (strings.HasPrefix(text[i:], "seven")) {
      newLine += "7"
    } else if (strings.HasPrefix(text[i:], "eight")) {
      newLine += "8"
    } else if (strings.HasPrefix(text[i:], "nine")) {
      newLine += "9"
    } else if (text[i] >= 48 && text[i] <= 57) {
      newLine += string(text[i])
    }
  }
  return newLine
}

func main() {
  file, _ := os.Open("codes.txt")
  scanner := bufio.NewScanner(file)
  var sum int = 0
  for scanner.Scan() {
    var calNum = Text2Num(scanner.Text())
    var calCode = calNum[0:1] + calNum[len(calNum)-1:]
    calInt, _ := strconv.Atoi(calCode)
    fmt.Println("  Value: ", scanner.Text(), " --> ", calInt)
    sum += calInt
  }
  fmt.Println("Sum: ", sum)
}
