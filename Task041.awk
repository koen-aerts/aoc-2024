#!/usr/bin/awk -f
function countWins(winNums, ownNums) {
  score = 0
  for (i in winNums) {
    for (j in ownNums) {
      if (winNums[i] == ownNums[j]) {
        if (score == 0) {
          score += 1
        } else {
          score *= 2
        }
      }
    }
  }
  return score
}
BEGIN {
  FS="|"
  totscore = 0
}
{
  split($1, wins, ":")
  split(wins[2], winNums, " ")
  split($2, ownNums, " ")
  score = countWins(winNums, ownNums)
  totscore += score
  print wins[1], ": ", score
}
END {
  print "Total: ", totscore
}
