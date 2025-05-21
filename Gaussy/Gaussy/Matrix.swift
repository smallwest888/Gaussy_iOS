//
//  Matrix.swift
//  Gaussy
//
//  Created by Yuhao
//

import Foundation
import Combine

class Matrix: ObservableObject {
    @Published var data: [[Int]]

    init(rows: Int, columns: Int) {
        self.data = Array(repeating: Array(repeating: 0, count: columns), count: rows)
        self.randomize()
    }

    func randomize() {
        // 首先创建一个单位矩阵
        for i in 0..<data.count {
            for j in 0..<data[i].count {
                data[i][j] = i == j ? 1 : 0
            }
        }
        
        // 随机进行行变换操作
        let numberOfOperations = data.count * 2 // 确保有足够的操作次数
        
        for _ in 0..<numberOfOperations {
            let operation = Int.random(in: 0...2)
            switch operation {
            case 0: // 交换行
                let row1 = Int.random(in: 0..<data.count)
                let row2 = Int.random(in: 0..<data.count)
                if row1 != row2 {
                    swapRows(row1, row2)
                }
            case 1: // 缩放行
                let row = Int.random(in: 0..<data.count)
                let scalar = Int.random(in: -2...2)
                if scalar != 0 {
                    scaleRow(row, by: Double(scalar))
                }
            case 2: // 行加法
                let sourceRow = Int.random(in: 0..<data.count)
                let targetRow = Int.random(in: 0..<data.count)
                if sourceRow != targetRow {
                    addRow(sourceRow, to: targetRow)
                }
            default:
                break
            }
        }
    }

    func swapRows(_ row1: Int, _ row2: Int) {
        guard row1 < data.count && row2 < data.count else { return }
        let temp = data[row1]
        data[row1] = data[row2]
        data[row2] = temp
    }

    func swapColumns(_ col1: Int, _ col2: Int) {
        guard col1 < data[0].count && col2 < data[0].count else { return }
        for i in 0..<data.count {
            let temp = data[i][col1]
            data[i][col1] = data[i][col2]
            data[i][col2] = temp
        }
    }

    func scaleRow(_ row: Int, by scalar: Double) {
        guard row < data.count else { return }
        for i in 0..<data[row].count {
            let result = Double(data[row][i]) * scalar
            // 检查结果是否为整数
            if abs(result - round(result)) < 1e-10 {
                data[row][i] = Int(round(result))
            }
        }
    }

    func addRow(_ sourceRow: Int, to targetRow: Int) {
        guard sourceRow < data.count && targetRow < data.count else { return }
        for i in 0..<data[targetRow].count {
            data[targetRow][i] += data[sourceRow][i]
        }
    }

    // 打印矩阵
    func printMatrix() {
        for row in data {
            print(row.map { String($0) }.joined(separator: " "))
        }
    }

    // 检查矩阵是否为单位矩阵
    func isIdentity() -> Bool {
        for i in 0..<data.count {
            for j in 0..<data[i].count {
                if (i == j && data[i][j] != 1) || (i != j && data[i][j] != 0) {
                    return false
                }
            }
        }
        return true
    }
    
    // 检查矩阵是否可解
    func isSolvable() -> Bool {
        // 检查每一行是否至少有一个非零元素
        for row in data {
            if row.allSatisfy({ $0 == 0 }) {
                return false
            }
        }
        return true
    }
}
