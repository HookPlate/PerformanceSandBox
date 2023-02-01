//
//  ContentView.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import SwiftUI
//this class is generic over some kind of value, could be a string or anything
class Debouncer<T>: ObservableObject {
    //it has published properties of both input and output both of which are the same type that came in. If a String comes in, a string goes out..
    @Published var input: T
    @Published var output: T
    
    private var debounce: AnyCancellable?
    
    init(initialValue: T, delay: Double = 1) {
        self.input = initialValue
        self.output = initialValue
        //when input changes wait a certain number of seconds and then write output to be that value.
        debounce = $input
        //the way debounce works is if another change comes in, ignore the first change and carry on waiting for the elapsed time.
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.output = $0
            }
    }
    
    //create our debounce using combine
    
}
struct ContentView: View {
    @StateObject private var text = Debouncer(initialValue: "", delay: 0.5)
    @StateObject private var slider = Debouncer(initialValue: 0.0, delay: 0.1)
    
    var body: some View {
        VStack {
            //modifies the input from our Debouncer text
            TextField("Search for something", text: $text.input)
                .textFieldStyle(.roundedBorder)
            //this displays the output for the text
            Text(text.output)
            //nice use of Spacer and formatted()
            Spacer().frame(height: 50)
            //wait until I've finished sliding then update
            Slider(value: $slider.input, in: 0...100)
            Text(slider.output.formatted())
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
