#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Rainbow

let board = [
    [ 0, 0, 0, 1, 1, 0, 0, 0 ],
    [ 1, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 1, 0 ],
    [ 0, 0, 0, 0, 0, 0, 1, 0 ],
    [ 0, 0, 1, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 1 ],
    [ 0, 1, 1, 0, 1, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ]
]

var neighbouringMines = [
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ]
]

var guessed = [
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0 ]
]

for i in 0...7 {
    for x in 0...7 {
        var count = 0
        if i >= 1 {
            count += board[i - 1][x]
            if x >= 1 {
                count += board[i - 1][x - 1]
            }
            if x <= 6 {
                count += board[i - 1][x + 1]
            }
        }
        if i <= 6 {
            count += board[i + 1][x]
            if x >= 1 {
                count += board[i + 1][x - 1]
            }
            if x <= 6 {
                count += board[i + 1][x + 1]
            }
        }
        if x >= 1 {
            count += board[i][x - 1]
        }
        if x <= 6 {
            count += board[i][x + 1]
        }
        neighbouringMines[i][x] = count
    }
}

func revealSurroundingEmptySpaces(_ coords: [Int]) {
    if coords[0] > 0 { // up
        for temp in (0...coords[0]).reversed() {
            guessed[temp][coords[1]] = 1
            if neighbouringMines[temp][coords[1]] != 0 { break }
        }
    }
    if coords[0] < 7 { // down
        for temp in coords[0]...7 {
            guessed[temp][coords[1]] = 1
            if neighbouringMines[temp][coords[1]] != 0 { break }
        }
    }
    if coords[1] > 0 { // left
        for temp in (0...coords[1]).reversed() {
            guessed[coords[0]][temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
    if coords[1] < 7 { // right
        for temp in coords[1]...7 {
            guessed[coords[0]][temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
    if coords[0] > 0 && coords[1] > 0 { // diagonally up and to the left
        for temp in 0...(coords[0] < coords[1] ? coords[0] : coords[1]) {
            guessed[coords[0] - temp][coords[1] - temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
    if coords[0] < 7 && coords[1] < 7 { // diagonally down and to the right
        for temp in 0...(7 - (coords[0] < coords[1] ? coords[0] : coords[1])) {
            guessed[coords[0] + temp][coords[1] + temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
    if coords[0] > 0 && coords[1] < 7 { // diagonally up and to the right
        for temp in 0...(coords[0] < 7 - coords[1] ? coords[0] : 7 - coords[1]) {
            guessed[coords[0] - temp][coords[1] + temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
    if coords[0] < 7 && coords[1] > 0 { // diagonally down and to the left
        for temp in 0...(7 - coords[0] < coords[1] ? 7 - coords[0] : coords[1]) {
            guessed[coords[0] + temp][coords[1] - temp] = 1
            if neighbouringMines[coords[0]][temp] != 0 { break }
        }
    }
}

while true {
    var toPrint = ""
    for i in 0...7 {
        for x in 0...7 {
            if guessed[i][x] == 1 {
                switch neighbouringMines[i][x] {
                    case 0: toPrint += " 0 ".onGreen
                    case 1: toPrint += " 1 ".onYellow
                    case 2: toPrint += " 2 ".onLightRed
                    default: toPrint += " \(neighbouringMines[i][x]) ".onRed
                }
            } else {
                toPrint += " _ "
            }
        }
        toPrint += "\n"
    }
    print(toPrint)
    var coords = [ -1, -1 ]
    while (coords[0] < 0 || coords[0] > 7) || (coords[1] < 0 || coords[1] > 7) {
        let temp = (readLine() ?? "0 0").split(separator: " ")
        if temp.count < 2 {
            continue
        }
        coords[1] = (Int(temp[0]) ?? -1) - 1
        coords[0] = (Int(temp[1]) ?? -1) - 1
    }
    guessed[coords[0]][coords[1]] = 1
    if board[coords[0]][coords[1]] == 1 {
        exit(1)
    }
    revealSurroundingEmptySpaces(coords)
    print("\u{001B}[H\u{001B}[2J")
}