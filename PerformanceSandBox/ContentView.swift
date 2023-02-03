//
//  ContentView.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import SwiftUI

//class Debouncer<T>: ObservableObject {
//    @Published var input: T
//    @Published var output: T
//
//    private var debounce: AnyCancellable?
//
//    init(initialValue: T, delay: Double = 1) {
//        self.input = initialValue
//        self.output = initialValue
//
//        debounce = $input
//            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
//            .sink { [weak self] in
//                self?.output = $0
//            }
//    }
//}
//
class SaveData: ObservableObject {
    @Published var highScore = 0
}

//struct ContentView: View {
//    @StateObject @DebouncedObservedObject var saveData = SaveData()
//
//    var body: some View {
//        VStack {
//            Button("High Score: \(saveData.highScore )") {
//                saveData.highScore += 1
//            }
//            OtherView(saveData: saveData)
//        }
//    }
//}
//
//struct OtherView: View {
//    @ObservedObject var saveData: SaveData
//
//    var body: some View {
//        Text("Your score is: \(saveData.highScore)")
//    }
//}

struct DisplayingView: View {
    @EnvironmentObject var saveData: SaveData
    
    var body: some View {
        print("In DipslayingView.body")
        return Text("Your high score is \(saveData.highScore)")
    }
    
    init() {
        print("In DisplayingView.init")
    }
}
 
struct UpdatingView: View {
    @EnvironmentObject var saveData: SaveData
    //her needs the return to return only one view I think
    var body: some View {
        print("In UpdatingView.body")
        return Button("Add to high score") {
            saveData.highScore += 1
        }
        
    }
    init() {
        print("In UpdatingView.init")
    }
}

struct ContentView: View {
    @StateObject var saveData = SaveData()
    
    var body: some View {
        print("In ContentView.body")
        return VStack {
            DisplayingView()
            UpdatingView()
        }
        .environmentObject(saveData)
    }
    init() {
        print("In ContentView.init")
    }
}


//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
