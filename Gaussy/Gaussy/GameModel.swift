//
//  GameModel.swift
//  Gaussy
//
//  Created by Yuhao Hu
//

import Foundation

var matrix:  = Matrix
    var moves: Int = 0
    var startTime: Date?
    var isGameCompleted: Bool {
        return checkIfSolved()
    }

    enum MoveType {
        case swapRows(Int, Int)
        case swapColumns(Int, Int)
        case scaleRow(Int, Int)
        case addRow(Int, Int)
    }

    init(size: Int) {
        matrix = Matrix(rows: size, columns: size)
        // 根据游戏的难度级别初始化矩阵
        initializeMatrix(for: size)
    }

    private func initializeMatrix(for size: Int) {
        // 初始化矩阵逻辑，根据难度级别可能需要调整
    }

    func startGame() {
        startTime = Date()
        moves = 0
    }

    func makeMove(_ type: MoveType) {
        switch type {
        case .swapRows(let row1, let row2):
            matrix.swapRows(row1, row2)
        case .swapColumns(let col1, let col2):
            matrix.swapColumns(col1, col2)
        case .scaleRow(let row, let scalar):
            matrix.scaleRow(row, by: scalar)
        case .addRow(let sourceRow, let targetRow):
            matrix.addRow(sourceRow, to: targetRow)
        }

        moves += 1
    }

    private func checkIfSolved() -> Bool {
        // 检查矩阵是否达到了单位矩阵的状态
        // 这里需要实现具体的检查逻辑
    }

    func getGameDuration() -> TimeInterval? {
        guard let startTime = startTime else { return nil }
        return -startTime.timeIntervalSinceNow
    }

    // 可以添加更多方法，如重置游戏等

