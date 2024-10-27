//
//  GameViewModel.swift
//  Gaussy
//
//  Created by 胡宇豪 on 2024/1/7.
//

import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var matrix: Matrix
    @Published var moves: Int
    @Published var finished: Bool
    @Published var gameTime: Double
    @Published var curGameTime: Double
    var timer: Timer?
    var startTime: Date
    var matrixSize: Int

    init(matrixSize: Int) {
        self.matrixSize = matrixSize
        self.matrix = Matrix(rows: matrixSize, columns: matrixSize)
        self.startTime = Date()
        self.moves = 0
        self.finished = false
        self.gameTime = 0.0
        self.curGameTime = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            self.curGameTime += 0.1
        }
    }

    // New Game
    func newGame() {
        self.matrix = Matrix(rows: matrixSize, columns: matrixSize)
        self.moves = 0
        self.startTime = Date()
        self.finished = false
        self.gameTime = 0.0
        self.curGameTime = 0.0
        // 这里可以添加初始化矩阵的逻辑，比如填充随机值或特定模式
    }

    // Diffrent Level

    func changeDifficulty(increase: Bool) {
        if increase {
            matrixSize = min(6, matrixSize + 1)
        } else {
            matrixSize = max(2, matrixSize - 1)
        }
        newGame() // Reset Game
    }

    // Swap Rows
    func swapRows(_ row1: Int, _ row2: Int) {
        matrix.swapRows(row1, row2)
        moves += 1
        checkGameCompletionAndUpdateGameDuration()
    }

    // Swap Cols
    func swapColumns(_ col1: Int, _ col2: Int) {
        matrix.swapColumns(col1, col2)
        moves += 1
        checkGameCompletionAndUpdateGameDuration()
    }
    
//    func swapColumnLeft(_ col: Int) {
//        guard col > 0 else { return }
//        matrix.swapColumns(col, col - 1)
//        moves += 1
//        checkGameCompletionAndUpdateGameDuration()
//    }
//
//    func swapColumnRight(_ col: Int) {
//        guard col < matrix.data.first?.count ?? 0 - 1 else { return }
//        matrix.swapColumns(col, col + 1)
//        moves += 1
//        checkGameCompletionAndUpdateGameDuration()
//    }


    func scaleRow(_ row: Int, by scalar: Double) {
        matrix.scaleRow(row, by: scalar)
        moves += 1
        checkGameCompletionAndUpdateGameDuration()
    }

    // addRow
    func addRow(_ sourceRow: Int, to targetRow: Int) {
        matrix.addRow(sourceRow, to: targetRow)
        moves += 1
        checkGameCompletionAndUpdateGameDuration()
    }

    // Calc Time
    func gameDuration() -> String {
        let duration = Date().timeIntervalSince(startTime)
        return String(format: "%.2f Sec", duration)
    }
    
    func getGameDuration() -> Double {
        let duration = Date().timeIntervalSince(startTime)
        return (duration * 10).rounded() / 10
    }

    // is Ur Game Finished?
    func checkGameCompletion() -> Bool {
        return matrix.isIdentity()
    }
    
    func checkGameCompletionAndUpdateGameDuration() {
        finished = checkGameCompletion()
        if finished {
            gameTime = curGameTime
        }
    }

}
