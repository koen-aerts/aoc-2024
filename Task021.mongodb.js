// MongoDB
// Example document after CSV import from clipboard, colon (:) as separator:
// { 
//    "_id" : ObjectId("656ba60c149b5b677135fcaa"), 
//    "Field_0" : "Game 1", 
//    "Field_1" : " 7 blue, 9 red, 1 green; 8 green; 10 green, 5 blue, 3 red; 11 blue, 5 red, 1 green"
// }
let tot = 0;
const re = /[^0-9]/g;
db.getCollection("games").find({}).forEach((game) => {
  const gameId = parseInt(game.Field_0.replace(re, ""));
  const sets = game.Field_1.split(";");
  let isPossible = true;
  for (const set of sets) {
    const colours = set.split(",");
    for (const colour of colours) {
      const amount = parseInt(colour.replace(re, ""));
      if (colour.indexOf("red") >= 0) {
        if (amount > 12) {
          isPossible = false;
          break;
        }
      } else if (colour.indexOf("green") >= 0) {
        if (amount > 13) {
          isPossible = false;
          break;
        }
      } else if (colour.indexOf("blue") >= 0) {
        if (amount > 14) {
          isPossible = false;
          break;
        }
      }
    }
  }
  print(game.Field_0 + ": " + isPossible)
  if (isPossible) {
    tot += gameId + 0;
  }
})
print("Sum: " + tot);
