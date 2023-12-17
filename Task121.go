package main

import (
  "fmt"
  "strings"
  "strconv"
  "bufio"
  "os"
)

func CountCombos(text string) int {
  recs := strings.Split(text, " ")
  bits := strings.Split(recs[1], ",")
  spacers := make([]int, len(bits) + 1)
  totChars := 0
  fmt.Println("  Value: ", recs[0])
  pieces := make([]string, len(bits))
  minWidth := 0
  totSpaces := 0
  for i, width := range bits {
    var newPiece string = ""
    widthInt, _ := strconv.Atoi(width)
    for j := 0; j < widthInt; j++ {
      newPiece += "#"
      minWidth += 1
      totChars += 1
    }
    if i > 0 { minWidth += 1 }
    totSpaces = len(recs[0]) - totChars
    pieces[i] = newPiece
  }
  maxFill := len(recs[0]) - minWidth
  for i, _ := range spacers {
    if (i == 0) {
      spacers[0] = 0
    } else if (i == len(spacers)-1) {
      spacers[i] = maxFill
    } else {
      spacers[i] = 1
    }
  }
  lastRound := false
  if (spacers[0] == maxFill && spacers[len(spacers)-1] == 0) {
    lastRound = true
  }
  matchCnt := 0
  for {
    var myRec string = ""
    for i, piece := range pieces {
      for j := 0; j < spacers[i]; j++ {
        myRec += "."
      }
      myRec += piece
    }
    for j := 0; j < spacers[len(spacers)-1]; j++ {
      myRec += "."
    }
    //fmt.Println("  combo: ", myRec)
    var myMatch string = ""
    for i, ch := range recs[0] {
      if string(ch) == "?" {
        myMatch += "?"
      } else {
        myMatch += string(myRec[i])
      }
    }
    //fmt.Println("  match: ", myMatch)
    if (myMatch == recs[0]) {
      matchCnt += 1
    }
    if (lastRound) {
      break
    }
    for j := len(spacers)-2; j >= 0; j-- {
      spacers[j] += 1
      sum := 0
      for k := 0; k <= len(spacers)-2; k++ {
        sum += spacers[k]
      }
      if (sum <= totSpaces) {
        spacers[len(spacers)-1] = totSpaces - sum
        break
      }
      if j > 0 {
        spacers[j] = 1
      } else {
        spacers[j] = 0
      }
    }
    if (spacers[0] == maxFill && spacers[len(spacers)-1] == 0) {
      lastRound = true
    }
  }
  
  return matchCnt
}

func main() {
  file, _ := os.Open("springs.txt")
  scanner := bufio.NewScanner(file)
  var sum int = 0
  for scanner.Scan() {
    var combos = CountCombos(scanner.Text())
    fmt.Println("  Value: ", combos)
    sum += combos
  }
  fmt.Println("Sum: ", sum)
}
