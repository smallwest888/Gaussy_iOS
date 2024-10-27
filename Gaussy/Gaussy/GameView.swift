//
//  GameView.swift
//  Gaussy
//
//  Created by Yuhao
//

import SwiftUI
import UniformTypeIdentifiers

struct Item: Identifiable, Codable {
    var id: UUID
    var name: String
    var steps: Int
    var time: Double
}

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showingScaleActionSheet = false
    @State private var selectedRow: Int?
    @State private var selectedColumn: Int?
    @State private var draggingRow: Int?
    @State private var showPopUp: Bool = false
    @State private var showRanking: Bool = false
    @State private var scalarActive: Bool = false
    @State private var success: Bool = false
    @State var toast: Toast? = nil
    @AppStorage("rankDataStr") private var rankDataStr: String = "[]"
    
    var body: some View {
        VStack {
            Text("Gaussy Game")
                .font(.largeTitle)
                .padding()
            HStack {
                Text("Time: \(String(format: "%.1fs", success ? viewModel.gameTime : viewModel.curGameTime))")
                Text("Level: \(viewModel.matrixSize <= 3 ?  "easy" : viewModel.matrixSize >= 5 ? "hard" : "medium")")
                Text("Steps: \(viewModel.moves)")
                    .padding(10)
                
            }
           
                Button("New Game") {
                    viewModel.newGame()
                    success = false
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                Menu("Ranking") {
                    Button("Check Ranking") {
                        showRanking = true
                    }
                    
                    Button("Clean Up") {
                        rankDataStr = "[]"
                    }
                }
                .padding()
            
            ScalarView(matrix: viewModel.matrix, selectedRow: $selectedRow, toast: $toast, scalarActive: $scalarActive, viewModel: viewModel)
        }
        
        Spacer()
        
        ZStack {
            MatrixView(matrix: viewModel.matrix, selectedRow: $selectedRow,
                       selectedColumn: $selectedColumn,
                       draggingRow: $draggingRow, showingScaleActionSheet: $showingScaleActionSheet,
                       scalarActive: $scalarActive,
                       success: $success,viewModel: viewModel).padding(.bottom, 30)
            //                HStack {
            //                    Button("查看排行榜") {
            //                        showRanking = true
            //                    }
            //                    .padding()
            //                    .background(Color.gray)
            //                    .foregroundColor(.white)
            //                    .cornerRadius(10)
            //
            //                    Button("清空排行榜") {
            //                        rankDataStr = "[]"
            //                    }
            //                    .padding()
            //                    .background(Color.red)
            //                    .foregroundColor(.white)
            //                    .cornerRadius(10)
            //
            //                }
            //                .padding()
        }
        .toastView(toast: $toast)
        .onChange(of: viewModel.finished) { newVal in
            if newVal == true {
                success = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Maybe Some new Randern here
                    showPopUp = true
                }
            }
            
        }
        if showPopUp {
            GameResultInputDialog(show: $showPopUp, viewModel: viewModel, showRanking: $showRanking)
            
        }
        if showRanking {
            GameResultInputDialog(show: $showPopUp, viewModel: viewModel, showRanking: $showRanking)
        }
        
        
        Spacer()
        
        VStack {
            // Menu P.S. Here Should Redesign
            HStack {
                Button("Too Easy") {
                    if success == false {
                        viewModel.changeDifficulty(increase: true)
                    }
                    
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                
                Button("Too Hard!") {
                    if success == false {
                        viewModel.changeDifficulty(increase: false)
                    }
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
    }
}
    



struct MatrixView: View {
    @ObservedObject var matrix: Matrix
    @Binding var selectedRow: Int?
    @Binding var selectedColumn: Int?
    @Binding var draggingRow: Int?
    @Binding var showingScaleActionSheet: Bool
    @Binding var scalarActive: Bool
    @Binding var success: Bool
    var viewModel: GameViewModel
    
    func getBackgroundColor(row: Int, column: Int, selectedRow: Int?, selectedColumn: Int?, success: Bool) -> Color {
        if success {
            if row == column {
                return Color.yellow
            } else {
                return Color.clear
            }
        } else {
            if row == selectedRow || column == selectedColumn {
                return Color.blue.opacity(0.2)
            } else {
                return Color.clear
            }
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<matrix.data.count, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<matrix.data[row].count, id: \.self) { column in
                        Text("\(matrix.data[row][column])")
                            .frame(width: 50, height: 50)
                            .background(getBackgroundColor(row: row, column: column, selectedRow: selectedRow, selectedColumn: selectedColumn, success: success)
                            )
                            .cornerRadius(5)
                            .rotationEffect(Angle(degrees: !success ? 0 : -5))
                            .animation(success && row==column ? Animation.easeInOut(duration: 0.2).repeatForever(autoreverses: true) : Animation.easeInOut(duration: 0), value: UUID())
                            
                            .onTapGesture(count: 2) {
                                scalarActive = false
                                selectedRow = nil
                                if selectedColumn == column {
                                    selectedColumn = nil
                                } else if selectedColumn == nil {
                                    selectedColumn = column
                                } else {
                                    viewModel.swapColumns(selectedColumn!, column)
                                    selectedColumn = column
                                }
                            }
                            .onTapGesture {
                                scalarActive = false
                                selectedColumn=nil
                                if selectedRow == row {
                                    selectedRow = nil
                                } else if selectedRow == nil {
                                    selectedRow = row
                                    scalarActive = true
                                } else {
                                    viewModel.swapRows(selectedRow!, row)
                                    selectedRow = row
                                    scalarActive = true
                                }
                            }
                            
                            .onDrag {
                                self.draggingRow = row
                                return NSItemProvider(object: String(row) as NSString)
                            }
//                            .onLongPressGesture {
//
//                                selectedRow = row
//                                selectedColumn = nil
//                                scalarActive = true
//                            }
                            .onDrop(of: [UTType.plainText], isTargeted: nil) { providers, _ in
                                providers.first?.loadDataRepresentation(forTypeIdentifier: UTType.plainText.identifier) { data, _ in
                                    if let data = data, let string = String(data: data, encoding: .utf8),
                                       let sourceRow = Int(string), sourceRow != row {
                                        viewModel.addRow(sourceRow, to: row)
                                    }
                                }
                                return true
                            }
                            
                    }
                }
            }
        }
    }
}

struct ScalarView: View {
    @ObservedObject var matrix: Matrix
    @Binding var selectedRow: Int?
    @Binding var toast: Toast?
    @Binding var scalarActive: Bool
    @State private var numberInput: String = ""
    @State private var isInputValid: Bool = false
    var viewModel: GameViewModel

    var body: some View {
        HStack {
            Text("Scalar:")
                .opacity(selectedRow == nil ? 0.5 : 1)
            //            .padding()
            TextField("Enter a scalar number", text: $numberInput)
                .keyboardType(.numbersAndPunctuation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(selectedRow == nil)
            Button(action: {
                let res = checkAndConvertNumber(numberInput)
                if selectedRow == nil {
                    toast = Toast(style: .error, message: "Choose A Row")
                } else if res == nil {
                    toast = Toast(style: .error, message: "Wrong Input")
                } else {
                    var isValid = true
                    for index in 0..<matrix.data.count {
                        let num = matrix.data[selectedRow!][index]
                        let resNum: Double = Double(num) * res!

                        if checkDoubleIsInt(resNum) == false {
                            toast = Toast(style: .error, message: "You entered an incorrect value")
                            isValid = false
                            break
                        }
                    }
                    if isValid {
                        viewModel.scaleRow(selectedRow!, by: res!)
                        toast = Toast(style: .info, message: "Finished")
                    }
                }
            }) {
                Text("Confirm")
                    .padding()
                    .foregroundColor(selectedRow == nil ? .gray : .black)
//                    .background(Color.blue)
                    .cornerRadius(10)
            }.disabled(selectedRow == nil)
        }
        .padding(.leading, 25)
        .padding(.trailing, 20)
        .opacity(scalarActive ? 1 : 0)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    var isValid: Bool

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isValid ? Color.gray : Color.red, lineWidth: 1)
            )
    }
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(viewModel: GameViewModel(matrixSize: 3))
    }
}

