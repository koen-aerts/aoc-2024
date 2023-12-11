#!/usr/bin/env xcrun swift
import Foundation

public final class Task101 {
    private var pipeMap: Array<Array<Character>> = Array()
    private var distMap: Array<Array<Int>> = Array()
    private var startX: Int = -1
    private var startY: Int = -1

    private func readPipes(from fileUrl: URL) async throws {
        for try await line in fileUrl.lines {
            let r = line.range(of: "S")
            if let r = r {
                let index = line.distance(from: line.startIndex, to: r.lowerBound)
                startY = pipeMap.count
                startX = index
                print("Starting coords: (" + String(startY) + "," + String(startX) + ")")
            }
            let pipeRow: Array<Character> = Array(line)
            var distRow: Array<Int> = Array()
            for _ in 1...pipeRow.count {
                distRow.append(-1)
            }
            pipeMap.append(pipeRow)
            distMap.append(distRow)
        }
    }

    public func run() async throws {
        try await readPipes(from: URL(fileURLWithPath: "pipes.txt"))
        var matched = 1
        var currentDist = 0
        distMap[startY][startX] = currentDist
        while (matched > 0) {
            matched = 0
            for y in 1...pipeMap.count {
                for x in 1...pipeMap[y-1].count {
                    if (distMap[y-1][x-1] == currentDist) {
                        let ch = pipeMap[y-1][x-1]
                        if (ch == "S" ) {
                            if (y > 1 && (pipeMap[y-2][x-1] == "|" || pipeMap[y-2][x-1] == "F" || pipeMap[y-2][x-1] == "7")) { distMap[y-2][x-1] = currentDist + 1; matched+=1 } // above
                            if (x > 1 && (pipeMap[y-1][x-2] == "-" || pipeMap[y-1][x-2] == "F" || pipeMap[y-1][x-2] == "L")) { distMap[y-1][x-2] = currentDist + 1; matched+=1 } // left
                            if (y < pipeMap.count && (pipeMap[y][x-1] == "|" || pipeMap[y][x-1] == "L" || pipeMap[y][x-1] == "J")) { distMap[y][x-1] = currentDist + 1; matched+=1 } // below
                            if (x < pipeMap[y-1].count && (pipeMap[y-1][x] == "-" || pipeMap[y-1][x] == "7" || pipeMap[y-1][x] == "J")) { distMap[y-1][x] = currentDist + 1;matched+=1 } // right
                        } else if (ch == "|") {
                            if (y > 1 && (pipeMap[y-2][x-1] == "|" || pipeMap[y-2][x-1] == "F" || pipeMap[y-2][x-1] == "7") && distMap[y-2][x-1] == -1) { distMap[y-2][x-1] = currentDist + 1; matched+=1 } // above
                            if (y < pipeMap.count && (pipeMap[y][x-1] == "|" || pipeMap[y][x-1] == "L" || pipeMap[y][x-1] == "J") && distMap[y][x-1] == -1) { distMap[y][x-1] = currentDist + 1; matched+=1 } // below
                        } else if (ch == "-") {
                            if (x > 1 && (pipeMap[y-1][x-2] == "-" || pipeMap[y-1][x-2] == "F" || pipeMap[y-1][x-2] == "L") && distMap[y-1][x-2] == -1) { distMap[y-1][x-2] = currentDist + 1; matched+=1 } // left
                            if (x < pipeMap[y-1].count && (pipeMap[y-1][x] == "-" || pipeMap[y-1][x] == "7" || pipeMap[y-1][x] == "J") && distMap[y-1][x] == -1) { distMap[y-1][x] = currentDist + 1;matched+=1 } // right
                        } else if (ch == "7") {
                            if (x > 1 && (pipeMap[y-1][x-2] == "-" || pipeMap[y-1][x-2] == "F" || pipeMap[y-1][x-2] == "L") && distMap[y-1][x-2] == -1) { distMap[y-1][x-2] = currentDist + 1; matched+=1 } // left
                            if (y < pipeMap.count && (pipeMap[y][x-1] == "|" || pipeMap[y][x-1] == "L" || pipeMap[y][x-1] == "J") && distMap[y][x-1] == -1) { distMap[y][x-1] = currentDist + 1; matched+=1 } // below
                        } else if (ch == "L") {
                            if (y > 1 && (pipeMap[y-2][x-1] == "|" || pipeMap[y-2][x-1] == "F" || pipeMap[y-2][x-1] == "7") && distMap[y-2][x-1] == -1) { distMap[y-2][x-1] = currentDist + 1; matched+=1 } // above
                            if (x < pipeMap[y-1].count && (pipeMap[y-1][x] == "-" || pipeMap[y-1][x] == "7" || pipeMap[y-1][x] == "J") && distMap[y-1][x] == -1) { distMap[y-1][x] = currentDist + 1;matched+=1 } // right
                        } else if (ch == "J") {
                            if (y > 1 && (pipeMap[y-2][x-1] == "|" || pipeMap[y-2][x-1] == "F" || pipeMap[y-2][x-1] == "7") && distMap[y-2][x-1] == -1) { distMap[y-2][x-1] = currentDist + 1; matched+=1 } // above
                            if (x > 1 && (pipeMap[y-1][x-2] == "-" || pipeMap[y-1][x-2] == "F" || pipeMap[y-1][x-2] == "L") && distMap[y-1][x-2] == -1) { distMap[y-1][x-2] = currentDist + 1; matched+=1 } // left
                        } else if (ch == "F") {
                            if (y < pipeMap.count && (pipeMap[y][x-1] == "|" || pipeMap[y][x-1] == "L" || pipeMap[y][x-1] == "J") && distMap[y][x-1] == -1) { distMap[y][x-1] = currentDist + 1; matched+=1 } // below
                            if (x < pipeMap[y-1].count && (pipeMap[y-1][x] == "-" || pipeMap[y-1][x] == "7" || pipeMap[y-1][x] == "J") && distMap[y-1][x] == -1) { distMap[y-1][x] = currentDist + 1;matched+=1 } // right
                        }
                    }
                }
            }
            if (matched > 0) {
                currentDist+=1
            }
        }
        print("Max distance: " + String(currentDist))
    }
}

let task = Task101()
try await task.run()
