//
//  DebouncedObservedObject.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import Foundation
//you cannot debounce an observedobject (our @StateObject saveData() in ContentView) directly, you need to wrap it. This thing knows how to wrap other ObservableObjects (SaveData). So the Wrapped below is for SaveData. Our debouncer has to be ObservableObject to announce to the world 'I have changed' and the thing it's wrapping (SaveData) has to be observable otherwise we couldn't read .objectWillChange for the subscription.
//when we have @dynamicMemberLookup we must have our custom subscript so Swift knows to read the wrapped value when access properties on the parent type but when we use propertywrapper that requirement is baked in.
@propertyWrapper

class DebouncedObservedObject<Wrapped: ObservableObject>: ObservableObject {
    var wrappedValue: Wrapped
    private var subscription: AnyCancellable?
    
    init(wrappedValue: Wrapped, delay: Double = 1) {
        self.wrappedValue = wrappedValue
        
        subscription = wrappedValue.objectWillChange
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
    }
//depsite commenting out this custom subscript we'll still have on available to us.
//    subscript<Value>(dynamicMember keypath: ReferenceWritableKeyPath<Wrapped, Value>) -> Value {
//        get {wrappedValue[keyPath: keypath]}
//        set {wrappedValue[keyPath: keypath] = newValue}
//    }
}
