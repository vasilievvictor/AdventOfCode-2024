//
//  AOC_day17.swift
//
//  Created by Виктор Васильев on 17.12.2024.
//  [Связаться со мной в Telegram](https://t.me/Victor_SMK)
//  Ссылка на репозиторий: https://github.com/vasilievvictor/AdventOfCode-2024/

import Foundation

// Читаем файл
let fileURL = URL(fileURLWithPath: "/Users/viktorvasilev/Documents/input")
let contents = try! String(contentsOf: fileURL, encoding: .utf8)
let lines = contents.split(separator: "\n")

var abc = [Int]()
var arr = [Int]()

for line in lines {
    if abc.count < 3 {
        let temp = line.split(separator: " ")
        abc.append(Int(temp[2])!)
    } else {
        let temp = line.split(separator: " ")
        arr = temp[1].split(separator: ",").map{Int($0)!}
    }
    
}

//Part 1
func poisk1(_ abc: [Int], _ arr: [Int]) -> [Int] {
        var registers = ["A": abc[0], "B": abc[1], "C": abc[2]]
        var instructionPointer = 0
        var ans: [Int] = []

        // Функция для получения значения combo операнда
        func comboOperandValue(_ operand: Int) -> Int {
            switch operand {
            case 0...3: return operand
            case 4: return registers["A"]!
            case 5: return registers["B"]!
            case 6: return registers["C"]!
            default: return 0
            }
        }
        
        while instructionPointer < arr.count {
            let opcode = arr[instructionPointer]
            let operand = arr[instructionPointer + 1]
            
            switch opcode {
            case 0: // adv - деление для A
                let denominator = Int(pow(2.0, Double(comboOperandValue(operand))))
                if denominator != 0 {
                    registers["A"] = registers["A"]! / denominator
                }
                
            case 1: // bxl - XOR для B и литерального операнда
                registers["B"] = registers["B"]! ^ operand
                
            case 2: // bst - B = comboOperand % 8
                registers["B"] = comboOperandValue(operand) % 8
                
            case 3: // jnz - переход, если A != 0
                if registers["A"]! != 0 {
                    instructionPointer = operand
                    continue
                }
                
            case 4: // bxc - XOR для B и C
                registers["B"] = registers["B"]! ^ registers["C"]!
                
            case 5: // out - вывод значения comboOperand % 8
                ans.append(comboOperandValue(operand) % 8)
                
            case 6: // bdv - деление для B
                let denominator = Int(pow(2.0, Double(comboOperandValue(operand))))
                if denominator != 0 {
                    registers["B"] = registers["A"]! / denominator
                }
                
            case 7: // cdv - деление для C
                let denominator = Int(pow(2.0, Double(comboOperandValue(operand))))
                if denominator != 0 {
                    registers["C"] = registers["A"]! / denominator
                }
                
            default:
                break // Некорректная инструкция
            }
            
            // Переход к следующей инструкции
            instructionPointer += 2
        }
        
        return ans

    }


print("AOC Day 17. Part 1 = \(poisk1(abc, arr).map{String($0)}.joined(separator: ","))")

//Part 2
func poisk2_slow(program: [Int], b: Int = 0, c: Int = 0) -> Int? {
    //слишком долго
    var a = 1  // Начинаем с минимального положительного значения
    while true {
        if poisk1([a, b, c], program) == arr {
            return a
        }
        a += 1
        
        // Добавим ограничение для предотвращения бесконечного цикла
        if a > 1_000_000_000  {
            print("Не найдено подходящее значение A в заданном диапазоне")
            return nil
        }
    }
}


func poisk2_fast(_ arr: [Int]) -> Int{
    var a = 1
    for i in 1...arr.count {
        for curr in a..<a << 3 {
            if poisk1([curr,0,0], arr) == Array(arr.suffix(i)) {
                a = curr
                break
            }
        }
        a = a << 3
    }
    return a >> 3
}

print("AOC Day 17. Part 2 = \(poisk2_fast(arr))")


