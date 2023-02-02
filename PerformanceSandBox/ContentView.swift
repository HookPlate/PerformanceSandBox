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
    //thanks to our @propertyWrapper this code becomes simpler too, this is two property wrappers in one, a nested property wrapper.
    //@StateObject var saveData = DebouncedObservedObject(wrappedValue: SaveData())
    @StateObject @DebouncedObservedObject var saveData = SaveData()
    
    var body: some View {
        Button("High Score: \(saveData.highScore )") {
            saveData.highScore += 1
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
