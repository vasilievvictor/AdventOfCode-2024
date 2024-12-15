//
//  AOC_day12.swift
//
//  Created by Виктор Васильев on 12.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

// Считываем файл в Set<Point>
struct Point: Hashable {
    var x: Int
    var y: Int
    var c: Character
}

var grid = Set<Point>()
var n = lines.count
var m = lines[0].count

for (i,line) in lines.enumerated() {
    for (j, c) in line.enumerated() {
        grid.insert(Point(x: i,y: j,c: c))
    }
}

//разбиваем на отдельные регионы Array<Set<Point>>
let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]

var regions = [Set<Point>]()

while !grid.isEmpty {
    let current = grid.removeFirst()
    var stack = [current]
    regions.append([current])
    
    while !stack.isEmpty {
        let cell = stack.removeLast()
        
        for (dx, dy) in directions {
            let newPoint = Point(x: cell.x + dx, y: cell.y + dy, c: cell.c)
            
            if grid.contains(newPoint){
                grid.remove(newPoint)
                stack.append(newPoint)
                regions[regions.count - 1].insert(newPoint)
            }
        }
    }
}

//Part 1
//считаем периметр регионов
func countRegionSize(_ regions: [Set<Point>]) -> Int {
    var ans = 0
    
    for region in regions {
        var perimetr = 0
        for point in region {
            for (dx, dy) in directions {
                let newPoint = Point(x: point.x + dx, y: point.y + dy, c: point.c)
                
                if !region.contains(newPoint) {
                    perimetr += 1
                }
            }
        }
        ans += perimetr * region.count
    }
    
    return ans
}

print("AOC Day 12. Part 1 = \(countRegionSize(regions))")

//Part 2
//создаем внешние и внутренние пути обхода для подсчета сторон

func countPaths(_ regions: [Set<Point>]) -> Int {
    var ans = 0
    var regions = regions
    
    while let region = regions.popLast() {
        let count_point = region.count
        
        var path: Set<Point> = []
    
        for point in region {
            
            for (i, (dx, dy)) in directions.enumerated() {
                let newPoint = Point(x: point.x + dx, y: point.y + dy, c: point.c)
                
                if !region.contains(newPoint) {
                    // i - где проходит забор 0/1/2/3 - снизу/сверху/справа/слева
                    path.insert(Point(x: newPoint.x, y: newPoint.y, c: String(i).first! ))
                }
            }
        }
        
        // считаем стены в регионе
        var count_wall = 0
        while let point = path.popFirst() {
            count_wall += 1
            
            if point.c == "2" || point.c == "3" {
                //идем вверх и вниз от point и удаляем смежные
                var next_x = point.x + 1
                let next_y = point.y
                while path.contains(Point(x: next_x, y: next_y, c: point.c)) {
                    path.remove(Point(x: next_x, y: next_y, c: point.c))
                    next_x += 1
                }
                
                next_x = point.x - 1
                while path.contains(Point(x: next_x, y: next_y, c: point.c)) {
                    path.remove(Point(x: next_x, y: next_y, c: point.c))
                    next_x -= 1
                }
            } else {
                //идем влево и вправо и удаляем смежные
                let next_x = point.x
                var next_y = point.y + 1
                while path.contains(Point(x: next_x, y: next_y, c: point.c)) {
                    path.remove(Point(x: next_x, y: next_y, c: point.c))
                    next_y += 1
                }
                
                next_y = point.y - 1
                while path.contains(Point(x: next_x, y: next_y, c: point.c)) {
                    path.remove(Point(x: next_x, y: next_y, c: point.c))
                    next_y -= 1
                }
            }
        }
        
        ans += count_wall * count_point
    }
    
    return ans
}

print("AOC Day 12. Part 2 = \(countPaths(regions))")
