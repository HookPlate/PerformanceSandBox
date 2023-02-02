//
//  DebouncedObservedObject.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import Foundation

@dynamicMemberLookup

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
    //to make the @dynamicMemberLookup work we need to say how we read values
    //the keypath is some kind of keypath where the type is our Wrapped type and the property type will be some Value type.
    subscript<Value>(dynamicMember keypath: ReferenceWritableKeyPath<Wrapped, Value>) -> Value {
        //when we're reading it just pass it on the thing we're wrapping, this is where we tell it which property to lookup
        get {wrappedValue[keyPath: keypath]}
        //when we're writing it we'll write the wrappedValue's keypath at the same location
        set {wrappedValue[keyPath: keypath] = newValue}
    }
    //this enables us to make the call site much cleaner
}
