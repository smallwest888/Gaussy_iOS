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
        if data.count == 2 {
            data[0][0] = 0
            data[0][1] = 1
            data[1][0] = 1
            data[1][1] = 0
        } else {
            for i in 0..<data.count {
                for j in 0..<data[i].count {
                    if data.count <= 3 {
                        data[i][j] = Int.random(in: 0...2)
                    } else if data.count <= 5 {
                        data[i][j] = Int.random(in: 0...5)
                    } else {
                        data[i][j] = Int.random(in: 0...9)
                    }
 
                }
            }
        }
    }

    func swapRows(_ row1: Int, _ row2: Int) {
        // 交换两行
        let temp = data[row1]
        data[row1] = data[row2]
        data[row2] = temp
    }

    func swapColumns(_ col1: Int, _ col2: Int) {
        // 交换两列
        for i in 0..<data.count {
            let temp = data[i][col1]
            data[i][col1] = data[i][col2]
            data[i][col2] = temp
        }
    }

    func scaleRow(_ row: Int, by scalar: Double) {
        // 将行缩放给定的整数因子
        guard row < data.count else { return }
        for i in 0..<data[row].count {
            data[row][i] = Int(Double(data[row][i]) * scalar)
        }
    }

    func addRow(_ sourceRow: Int, to targetRow: Int) {
        // 将一行添加到另一行
        guard sourceRow < data.count, targetRow < data.count else { return }
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
}
