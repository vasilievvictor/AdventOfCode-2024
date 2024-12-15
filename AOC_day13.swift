//
//  AOC_day13.swift
//
//  Created by Виктор Васильев on 13.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

var arr = [(ax: Int, ay: Int, bx: Int, by: Int, prx: Int, pry: Int)]()

for (i, line) in lines.enumerated() {
    
    if i % 3 == 0 {
        arr.append((ax: -1, ay: 0, bx: 0, by: 0, prx: 0, pry: 0))
    }
    
    let part = line.split(separator: " ")
    var ax: Int, ay: Int, bx: Int, by: Int, prx: Int, pry: Int
    if part.count == 4 {
        if arr[arr.count - 1].ax == -1 {
            
            var temp = part[2].split(separator: "+")[1]
            temp.popLast()
            ax = Int(temp)!
            
            ay = Int(part[3].split(separator: "+")[1])!
            arr[arr.count - 1].ax = ax
            arr[arr.count - 1].ay = ay
        } else {
            var temp = part[2].split(separator: "+")[1]
            temp.popLast()
            bx = Int(temp)!
            by = Int(part[3].split(separator: "+")[1])!
            arr[arr.count - 1].bx = bx
            arr[arr.count - 1].by = by
        }
    } else {
        var temp = part[1].split(separator: "=")[1]
        temp.popLast()
        prx = Int(temp)!
        pry = Int(part[2].split(separator: "=")[1])!
        arr[arr.count - 1].prx = prx
        arr[arr.count - 1].pry = pry
    }
}

//Part 1
func poisk1(_ arr: [(ax: Int, ay: Int, bx: Int, by: Int, prx: Int, pry: Int)]) -> Int {
    var ans = 0
    
    for curr in arr {
        var cur_x = 0
        var cur_y = 0
        var ans_curr = Int.max
        
        for i in 0..<100 {

            if cur_x == curr.prx && cur_y == curr.pry {
                ans_curr = min(ans_curr, i * 3)
                //break
            }
            var cur_x1 = cur_x
            var cur_y1 = cur_y
            
            for j in 0..<100 {

                if cur_x1 == curr.prx && cur_y1 == curr.pry {
                    ans_curr = min(ans_curr, i * 3 + j)
                    //break
                }
                
                cur_x1 += curr.bx
                cur_y1 += curr.by
            }
            
            cur_x += curr.ax
            cur_y += curr.ay
        }
        
        if ans_curr != Int.max {
            ans += ans_curr
        }
    }
    return ans
}

print("AOC Day 13. Part 1 = \(poisk1(arr))")

//Part 2
// Уравнения для решения:
// ax*k2 + bx*k2 = p1, ay*k1 + by*k2 = p2, решение для k1 и k2
// Эти уравнения будут иметь либо одно, либо ни одного решения
// упрощение этого методом подстановки дает нам:
// k2 = (p1 - ax*k1) / bx, k1 = (p2*bx - by*p1) / (bx*ay - by*ax)
// Решаем для k1 для точного целого значения, а затем подставляем для решения k2 для точного целого значения

func getCost(ax: Int, ay: Int, bx: Int, by: Int, p1: Int, p2: Int) -> Int {
    var cost: Int = 0
    let denomk1 = bx * ay - by * ax
    if denomk1 != 0 && bx != 0 { // если эти значения равны нулю, то значения будут неопределенными
        let k1num = p2 * bx - by * p1
        if k1num % denomk1 == 0 { // проверка на точное целое значение
            let k1 = k1num / denomk1
            let k2num = p1 - ax * k1
            if k2num % bx == 0 { // проверка на точное целое значение
                let k2 = k2num / bx
                cost = k1 * 3 + k2
            }
        }
    }
    return cost
}

func poisk2(_ arr: [(ax: Int, ay: Int, bx: Int, by: Int, prx: Int, pry: Int)]) -> Int {
    var ans = 0
    for curr in arr {
        ans += getCost(ax: curr.ax, ay: curr.ay, bx: curr.bx, by: curr.by, p1: curr.prx + 10000000000000, p2: curr.pry + 10000000000000)
    }
    return ans
}

print("AOC Day 13. Part 2 = \(poisk2(arr))")
