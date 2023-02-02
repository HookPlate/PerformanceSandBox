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
    //thanks to our @propertyWrapper this code becomes simpler too, this is two property wrappers in one, a nested property wrapper. This has a significant advantage since the propertyWrapper is invisible, we can use the saveData object directly.
    //@StateObject var saveData = DebouncedObservedObject(wrappedValue: SaveData())
    //the parameter for the delay is just (delay: 2) after @DebouncedObservedObject
    @StateObject @DebouncedObservedObject var saveData = SaveData()
    
    var body: some View {
        VStack {
            Button("High Score: \(saveData.highScore )") {
                saveData.highScore += 1
            }
            //the top one waits for the delay the bottom not. Used on a case by case basis.
            OtherView(saveData: saveData)
        }
    }
}

struct OtherView: View {
    //so if you were to use this below @DebouncedObservedObject they both be debounced.
    @ObservedObject var saveData: SaveData
    
    var body: some View {
        Text("Your score is: \(saveData.highScore)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
