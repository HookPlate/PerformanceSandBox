//
//  DebouncedObservedObject.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import Foundation
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
