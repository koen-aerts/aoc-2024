#!/usr/bin/awk -f
function countWins(winNums, ownNums) {
  score = 0
  for (i in winNums) {
    for (j in ownNums) {
      if (winNums[i] == ownNums[j]) {
        score += 1
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
  split(wins[1], cardPcs, " ")
  score = countWins(winNums, ownNums)
  if (!cards[cardPcs[2]]) {
    cards[cardPcs[2]] = 0
  }
  cards[cardPcs[2]]++
  if (score > 0) {
    for (i=1; i<=score; i++) {
      if (!cards[cardPcs[2]+i]) {
        cards[cardPcs[2]+i] = 0
      }
      cards[cardPcs[2]+i]+=cards[cardPcs[2]]
    }
  }
}
END {
  for (card in cards) {
    if (card) {
      totscore += cards[card]
    }
  }
  print "Total: ", totscore
}
