import SwiftUI

struct ContentView: View {
    private var data: [Int] = Array(1...9)
    private let colors: [Color] = [.red, .green, .blue]
    
    private let gridcolumns = [
        GridItem(.fixed(100)),
        GridItem(.fixed(100)),
        GridItem(.fixed(100))
    ]
    
    @State private var revealedIndices: Set<Int> = []
    @State private var currentSelection: [Int] = []
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridcolumns, spacing: 20) {
                    ForEach(data, id: \.self) { number in
                        Button(action: {
                            onTap(number: number)
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(revealedIndices.contains(number) ? colors[number % colors.count] : Color.gray)
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                Text("\(number)")
                                    .font(.title)
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Square Game")
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertMessage), dismissButton: .default(Text("OK"), action: {
                    // Clear for next round
                    revealedIndices.removeAll()
                    currentSelection.removeAll()
                }))
            }
        }
    }
    
    private func onTap(number: Int) {
        guard !revealedIndices.contains(number), currentSelection.count < 2 else { return }
        
        revealedIndices.insert(number)
        currentSelection.append(number)
        
        if currentSelection.count == 2 {
            let first = currentSelection[0]
            let second = currentSelection[1]
            
            if colors[first % colors.count] == colors[second % colors.count] {
                alertMessage = "You won!"
            } else {
                alertMessage = "You lost!"
            }
            
            showAlert = true
        }
    }
}

#Preview {
    ContentView()
}
