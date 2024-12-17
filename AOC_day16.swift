//
//  AOC_day16.swift
//
//  Created by Виктор Васильев on 16.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

var matrix = [[Int]]()
var start = (i: 0, j: 0)
var end = (i: 0, j: 0)

for line in lines {

    var temp = [Int]()
    
    for char in line {
        switch char {
        case "#": temp.append(-1)
        case "E": temp.append(Int.max); end = (i: matrix.count, j: temp.count - 1)
        case "S": temp.append(0); start = (i: matrix.count, j: temp.count - 1)
        default: temp.append(Int.max)
        }
    }
    matrix.append(temp)
}

//Part 1
func poisk1(_ matrix: [[Int]], _ start: (Int, Int), _ end: (Int, Int) ) -> (Int, [[Int]]) {
    var ans = 0
    var matrix = matrix
    var sdv = [(0,1), (-1,0), (0,-1), (1,0)]
    
    var stack = [(start.0, start.1, 0)]
    
    while !stack.isEmpty {
        let (x, y, napr) = stack.removeLast()
        
        for (i, (dx,dy)) in sdv.enumerated() {
            var new_zn = 2002
            if napr == (i + 1) % 4 || napr == (i + 3) % 4 {
                new_zn = 1001
            } else if napr == i {
                new_zn = 1
            }
            
            let new = matrix[x][y] + new_zn
            if matrix[x+dx][y+dy] > new {
                matrix[x+dx][y+dy] = new
                stack.append( (x+dx, y+dy, i) )
            }
        }
    }
    
    ans = matrix[end.0][end.1]
    
    return (ans, matrix)
}

let (opt_path, new_matrix) = poisk1(matrix, start, end)
print("AOC Day 16. Part 1 = \(opt_path)")


//Part 2
func poisk2(_ matrix: [[Int]], _ start: (Int, Int), _ end: (Int, Int), _ opt_path: Int ) -> Int {
   
    func dfs(_ matrix: inout [[Int]], x: Int, y: Int, napr: Int, zn: Int) {
        guard matrix[x][y] != -1 else { return }
        
        if let cachedZn = cache[x][y][napr], cachedZn <= zn - 2000 { return }
        cache[x][y][napr] = zn
        
        for (i, (dx,dy)) in sdv.enumerated() {
           
            var new_zn = 2002
            if napr == (i + 1) % 4 || napr == (i + 3) % 4 {
                new_zn = 1001
            } else if napr == i {
                new_zn = 1
            }
            
            let new = zn + new_zn
            
            if !set_curr.contains([x+dx, y+dy]) && matrix[x+dx][y+dy] != -1 && new <= opt_path && matrix[x+dx][y+dy] <= opt_path {
                
                set_curr.insert([x+dx, y+dy])
                
                dfs(&matrix, x: x+dx, y: y+dy, napr: i, zn: new)
                
                if x+dx == end.0 && y+dy == end.1 && new == opt_path {
                    set_path = set_path.union(set_curr)
                    print(set_path.count)
                }
                
                set_curr.remove([x+dx, y+dy])
            }
        }
        return
    }
    
    var set_path = Set<[Int]>()
    var set_curr = Set<[Int]>()
    let sdv = [(0,1), (-1,0), (0,-1), (1,0)]
    var matrix = matrix
    var cache = Array(repeating: Array(repeating: [Int?](repeating: nil, count: 4), count: matrix[0].count), count: matrix.count)
    
    set_path.insert([start.0, start.1])
    
    dfs(&matrix, x: start.0, y: start.1, napr: 0, zn: 0)
    
    return set_path.count
}

print("AOC Day 16. Part 2 = \(poisk2(new_matrix, start, end, opt_path))")
