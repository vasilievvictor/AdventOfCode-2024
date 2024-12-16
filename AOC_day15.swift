//
//  AOC_day15.swift
//
//  Created by Виктор Васильев on 15.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

var matrix = [[Int]]()
var moves = [String]()
let set_: Set<Character> = [">","<","^","v"]
var robot = (i: 0, j: 0)

for line in lines {
    if set_.contains(line.first!) {
        moves.append(String(line))
    } else {
        var temp = [Int]()
        for char in line {
            switch char {
            case "#": temp.append(-1)
            case "O": temp.append(1)
            case "@": temp.append(0); robot = (i: matrix.count, j: temp.count - 1)
            default: temp.append(0)
            }
        }
        matrix.append(temp)
    }
}

print(robot)
//print(matrix)
//print(moves)

//Part 1
func move(_ matrix: inout [[Int]], _ move: Character, i: Int, j: Int) -> (Int, Int){
    let dict = [">": (0,1), "<": (0,-1), "^": (-1,0), "v": (1,0)]
    let (dx, dy) = dict[String(move)]!
    var i1 = i
    var j1 = j
    var flag = true
    var count = 0
    
    
    w1: while i1 + dx < matrix.count && i1 + dx >= 0 && j1 + dy < matrix[i1].count && j1 + dy >= 0 {
        let new_i = i1 + dx, new_j = j1 + dy
        switch matrix[new_i][new_j] {
        case -1: flag = false; break w1 //стена
        case 0: count += 1; break w1 //пусто
        case 1: count += 1 //коробка
        default: continue
        }
        i1 += dx
        j1 += dy
    }
    
    if flag {
        for m in stride(from: count, to: 0, by: -1) {
            matrix[i + dx*m][j + dy*m] = matrix[i + dx*(m-1)][j + dy*(m-1)]
        }
        return (i + dx, j + dy)
    }
    return (i,j)

}

func poisk1(_ matrix: [[Int]], _ moves: [String], _ robot: (Int, Int)) -> Int {
    var ans = 0
    var matrix = matrix
    var robot = robot
    
    for line in moves {
        for m in line {
            robot = move(&matrix, m, i: robot.0, j: robot.1)
//            print (robot)
//            for line in matrix {
//                print(line)
//            }
        }
    }
    
    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            if matrix[i][j] == 1 {
                ans += i * 100 + j
            }
        }
    }
    
    return ans
}


print("AOC Day 15. Part 1 = \(poisk1(matrix, moves, robot))")


//Part 2



func poisk2(_ matrix: [[Int]], _ moves: [String], _ robot: (Int, Int)) -> Int {
    func move1(_ matrix: inout [[Int]], _ move: Character, i: Int, j: Int) -> (Int, Int){
        
        func dfs(_ matrix: inout [[Int]], _ i: Int, _ j: Int, dy: Int) -> Bool {
            print((i,j))
            if matrix[i][j] == -1 { return false }
            if matrix[i][j] == 0 { return true }
            var ans = false
            
            if matrix[i][j] == 1 {
                set_move.insert([i,j,1])
                set_move.insert([i,j + 1,2])
                ans = dfs(&matrix, i + dy, j, dy: dy) && dfs(&matrix, i + dy, j + 1, dy: dy)
            } else {
                set_move.insert([i,j-1,1])
                set_move.insert([i,j,2])
                ans = dfs(&matrix, i + dy, j, dy: dy) && dfs(&matrix, i + dy, j - 1, dy: dy)
            }
            return ans
        }
        
        let dict = [">": (0,1), "<": (0,-1), "^": (-1,0), "v": (1,0)]
        let (dx, dy) = dict[String(move)]!
        var set_move: Set<[Int]> = []
        
        if dx == 0 {
            var i1 = i
            var j1 = j
            var flag = true
            var count = 0
            
            w1: while i1 + dx < matrix.count && i1 + dx >= 0 && j1 + dy < matrix[i1].count && j1 + dy >= 0 {
                let new_i = i1 + dx, new_j = j1 + dy
                switch matrix[new_i][new_j] {
                case -1: flag = false; break w1
                case 0: count += 1; break w1
                case 1,2: count += 1
                default: continue
                }
                i1 += dx
                j1 += dy
            }
            
            if flag {
                for m in stride(from: count, to: 0, by: -1) {
                    matrix[i + dx*m][j + dy*m] = matrix[i + dx*(m-1)][j + dy*(m-1)]
                }
                //matrix[i][j] = 0
                return (i + dx, j + dy)
            }
        } else {
            //сдвиг вверх или вниз
            set_move.removeAll()
            if dfs(&matrix, i + dx, j, dy: dx) {
                //dfs1(i, j, dy: dy)
               // print(set_move)
                
                for curr in set_move {
                    matrix[curr[0]][curr[1]] = 0
                }
                for curr in set_move {
                    matrix[curr[0] + dx][curr[1]] = curr[2]
                }
                

                return (i + dx, j)
                
            }
        }
            return (i,j)
        }
    
    
    
    var ans = 0
    var matrix1 = [[Int]]()
    
    for line in matrix {
        var temp = [Int]()
        for x in line {
            if x == 1 {
                temp.append(1)
                temp.append(2)
            } else {
                temp.append(x)
                temp.append(x)
            }
        }
        matrix1.append(temp)
    }
    
    var robot1 = (robot.0, robot.1 * 2)
  
//    print(robot1)
//    for line in matrix1 {
//        print(line)
//    }
//    
    
    for line in moves {
        for m in line {
            robot1 = move1(&matrix1, m, i: robot1.0, j: robot1.1)
            print (robot1, m)
//            for line in matrix1 {
//                print(line)
//            }
        }
    }
    
    for i in 0..<matrix1.count {
        for j in 0..<matrix1[i].count {
            if matrix1[i][j] == 1 {
                ans += i * 100 + j
            }
        }
    }

    
//                for line in matrix1 {
//                    print(line)
//                }
    
    return ans
}

print(robot)
print("AOC Day 15. Part 2 = \(poisk2(matrix, moves, robot))")
