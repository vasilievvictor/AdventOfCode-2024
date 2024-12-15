//
//  AOC_day14.swift
//
//  Created by Виктор Васильев on 14.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

var arr = [(rx: Int, ry: Int, vx: Int, vy: Int)]()

for line in lines {
        
    let part = line.split(separator: " ")
    let part1 = part[0].split(separator: "=")[1]
    let part11 = part1.split(separator: ",").map{Int($0)!}
    
    let part2 = part[1].split(separator: "=")[1]
    let part22 = part2.split(separator: ",").map{Int($0)!}
    
    arr.append( (rx: part11[0], ry: part11[1], vx: part22[0], vy: part22[1]) )
}

//Part 1

func poisk1(_ arr: [(rx: Int, ry: Int, vx: Int, vy: Int)]) -> Int {
    var ans = 0
    var arr = arr
    
    for i in 0..<arr.count {
        for _ in 0..<100 {
            arr[i].rx = (101 + arr[i].rx + arr[i].vx) % 101
            arr[i].ry = (103 + arr[i].ry + arr[i].vy) % 103
//            arr[i].rx = (11 + arr[i].rx + arr[i].vx) % 11
//            arr[i].ry = (7 + arr[i].ry + arr[i].vy) % 7
        }
    }
    
   // print(arr)
    
    var kv1 = 0
    var kv2 = 0
    var kv3 = 0
    var kv4 = 0
    
    for i in 0..<arr.count {
        switch (arr[i].rx, arr[i].ry){
        case (0...49, 0...50): kv1 += 1
        case (51...100, 52...102): kv2 += 1
        case (0...49, 52...102): kv3 += 1
        case (51...100, 0...50): kv4 += 1
//        case (0...4, 0...2): kv1 += 1
//        case (6...10, 4...6): kv2 += 1; print(arr[i].rx, arr[i].ry)
//        case (0...4, 4...6): kv3 += 1
//        case (6...10, 0...2): kv4 += 1
        default: print("line")
        }
    }
    ans = kv1 * kv2 * kv3 * kv4
    return ans
}

print("AOC Day 14. Part 1 = \(poisk1(arr))")

//Part 2

func poisk2(_ arr: [(rx: Int, ry: Int, vx: Int, vy: Int)]) -> Int {
    var ans = -1
    var arr = arr
    var x_count = Array(repeating: 0, count: 101)
    var y_count = Array(repeating: 0, count: 103)
    
    for robot in arr {
        x_count[robot.rx] += 1
        y_count[robot.ry] += 1
    }
    
    for time in 0..<101*103 {
        for (i, robot) in arr.enumerated(){
            x_count[robot.rx] -= 1
            y_count[robot.ry] -= 1
            
            arr[i].rx = (101 + arr[i].rx + arr[i].vx) % 101
            arr[i].ry = (103 + arr[i].ry + arr[i].vy) % 103
            
            x_count[arr[i].rx] += 1
            y_count[arr[i].ry] += 1
        }
        
        if x_count.max()! >= 33 {
            //а дальше визуальная проверка всех близких случаев
            print(time + 1)
            var matrix = Array(repeating: Array(repeating: " ", count: 101), count: 103)
            
            for robot in arr {
                matrix[robot.ry][robot.rx] = "#"
            }
            
            for row in matrix {
                print(row.joined())
            }
        }
    }
    
    return ans
}


    print("AOC Day 14. Part 2 = \(poisk2(arr))")
