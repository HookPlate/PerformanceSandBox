//
//  DebouncedObservedObject.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import Foundation
//this wraps inside it some kind of object. That object can't be a string or an array. Its got to be also an ObdervedObject, something that conforms to the ObservableObject protocol. And this whole class can also announce changes, so it too must comform to ObservableObject. So what we are wrapping is observable and we ourselves are also observable.
class DebouncedObservedObject<Wrapped: ObservableObject>: ObservableObject {
    //this also must comformto the protocol
    var wrappedValue: Wrapped
    //debouncing work happens here
    private var subscription: AnyCancellable?
    
    //the inner one (wrapped value) changes regularly, our class will see it has changed and wait half a second to announce its own changes.
    init(wrappedValue: Wrapped, delay: Double = 1) {
        self.wrappedValue = wrappedValue
        
        //watch the thing wrapped inside us for changes
        subscription = wrappedValue.objectWillChange
        //wait some amount of time
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
        //then announce my own change upwards
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
        //now we can say we want the whole SaveData object to be debounced, done in ContentView
    }
}
