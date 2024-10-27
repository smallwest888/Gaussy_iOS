//
//  GaussyApp.swift
//  Gaussy
//
//  Created by Yuhao
//

import SwiftUI

@main
struct GaussyApp: App {
    var body: some Scene {
        WindowGroup {
            GameView(viewModel: GameViewModel(matrixSize: 3))
        }
    }
}

