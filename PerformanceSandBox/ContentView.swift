//
//  ContentView.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import SwiftUI

class Debouncer<T>: ObservableObject {
    @Published var input: T
    @Published var output: T
    
    private var debounce: AnyCancellable?
    
    init(initialValue: T, delay: Double = 1) {
        self.input = initialValue
        self.output = initialValue
        
        debounce = $input
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.output = $0
            }
    }
}

class SaveData: ObservableObject {
    @Published var highScore = 0
}
struct ContentView: View {
    //here is were we make the whole object debounced
    @StateObject var saveData = DebouncedObservedObject(wrappedValue: SaveData())
    
    var body: some View {
        //then we refer to the wrapped value, not just high score. The thing inside the DOO.
        //To see this in action run the app and click fast on the button, the change only happens after one second of inactivity.
        Button("High Score: \(saveData.wrappedValue.highScore )") {
            saveData.wrappedValue.highScore += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
