//
//  ContentView.swift
//  PerformanceSandBox
//
//  Created by Yoli on 01/02/2023.
//
import Combine
import SwiftUI

class SaveData: ObservableObject {
    @Published var highScore = 0
}


struct DisplayingView: View {
    //so with this new approach this view wants to read and be notified of changes so it stays as is
    @EnvironmentObject var saveData: SaveData
    
    var body: some View {
        print("In DipslayingView.body")
        return Text("Your high score is \(saveData.highScore)")
    }
    
    init() {
        print("In DisplayingView.init")
    }
}
// this view needs to write the data but never needs to read the data. Reading is handled in the other view. We changed some value somewhere and that's reflected somewhere else in our UI but this doesn't care if it changes and that's our mistake. We've told SwiftUI to watch it for changes and reinvoke when it does.
struct UpdatingView: View {
    //since here we want 'write only' data, without watching for changes, so here we want @Environment with the key we made, there's no type needed here, it comes from the environment automatically. This now means we need to inject this into the environment but this time as an environment value
//    @EnvironmentObject var saveData: SaveData
    @Environment(\.saveData) var saveData

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
    //Yes, that’s designed to hold value types rather than reference types, but in this instance it does exactly the same as using environment values rather than environment objects: it holds a reference to the object (keeps it alive), but doesn’t watch it for changes. If you changed teh whole object for a new SaveData() sure it would see that but changing values inside the class won't be seen so it won't reinvoke the body. Just know that we need to use @State now.
    //incidentally he didn't use private var here because it's clearly not private, he's posting it into the environment.
    @State var saveData = SaveData()
    
    var body: some View {
        print("In ContentView.body")
        return VStack {
            DisplayingView()
            UpdatingView()
        }
        //so this kind of code wont work anymore, we need to store a reference to it somewhere and inject it from there. See the new @State in ContView above
        //.environmentObject(SaveData())
        //now we send that as both an object and a key into the environment - crucial this bit.
        //this one wants to read and write and be observed.
        .environmentObject(saveData)
        //this one want to just write the data. Hence we need both to satisfy both views.
        .environment(\.saveData, saveData)
        
    }
    init() {
        print("In ContentView.init")
    }
}

//allows us to place a reference type (object/class) into the environment as a struct/value type.
struct SaveDataKey: EnvironmentKey {
    //with EnvironmentKeys you must provide a default value, so there's always a defualt value in there for us. So if there isn't one in the environment use this one.
    static var defaultValue = SaveData()
}

//now we can make an extension to handle reading and writing these things.
extension EnvironmentValues {
    var saveData: SaveData {
        //to read it we'll read the environment values for our SaveDataKey
        get { self[SaveDataKey.self] }
        //to write it we'll change our environment values (at SaveDataKey) to be our new value.
        set { self[SaveDataKey.self] = newValue }
    }
}



//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
