
import SwiftUI

struct PopupView<Content: View>: View {
    var content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                content
                    .background(Color.white)
                    .cornerRadius(10)
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}

struct GameResultInputDialog: View {
    @AppStorage("rankDataStr") private var rankDataStr: String = "[]"
    
    @Binding var show: Bool
    @State var name: String = ""
    var viewModel: GameViewModel
    @Binding var showRanking: Bool
    @State var rankData: [Item] = []
    
    var body: some View {
        PopupView{
            VStack {
                Text(showRanking ? "Your Rank!" : "Congratulations！")
                    .frame(maxWidth: .infinity)
                    .frame(height: 45, alignment: .center)
                    .font(Font.system(size: 23, weight: .semibold))
                    .foregroundColor(Color.black)
                    .padding()
                if showRanking {
                    VStack(alignment: .leading) {
                        ForEach(rankData.indices, id: \.self) { index in
                            Text("\(index + 1): \(rankData[index].name) steps: \(rankData[index].steps) time: \(String(format: "%.1fs", rankData[index].time))")
                                    }
                    }
                } else {
                    HStack {
                        Text("Name")
                        TextField("Type your name here", text: $name)
                            .textFieldStyle(CustomTextFieldStyle(isValid: name != ""))
                    }
                    .padding(.horizontal, 50)
                }
                Button(action: {
                    // Dismiss the PopUp
                    if show {
                        if name != "" {
                            let newItem = Item(id: UUID(), name: name, steps: viewModel.moves, time: viewModel.gameTime)
                            var rankData = getRankDataListFromStr(rankDataStr)
                            rankData.append(newItem)
                            rankData.sort { $0.time < $1.time }
                            if rankData.count > 5 {
                                let _ = rankData.popLast()
                            }
                            rankDataStr = getRankDataStrFromList(rankData)
                            show = false
                            showRanking = true
                        }
                    } else {
                        show = false
                        showRanking = false
                    }
                    
                    
                }, label: {
                    Text("OK!")
                        .frame(maxWidth: .infinity)
                        .frame(height: 54, alignment: .center)
                        .font(Font.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.blue)
                }).buttonStyle(PlainButtonStyle())
            }
        }.onAppear {
            rankData = getRankDataListFromStr(rankDataStr)
        }
    }
}
