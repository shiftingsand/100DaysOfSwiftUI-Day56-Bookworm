//
//  ContentView.swift
//  Bookworm
//
//  Created by Chris Wu on 5/27/20.
//  Copyright © 2020 Chris Wu. All rights reserved.
//

import SwiftUI

struct PushButton : View {
    let title : String
    @Binding var isOn : Bool
    
    var onColors = [Color.red, Color.yellow]
    var offColors = [Color(white: 0.6), Color(white: 0.4)]
    
    var body: some View {
        Button(title) {
            self.isOn.toggle()
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: isOn ? onColors : offColors), startPoint: .top, endPoint: .bottom))
        .foregroundColor(Color.white)
        .clipShape(Capsule())
        .shadow(radius: isOn ? 0 : 5)
    }
}

struct ContentView: View {
    @State private var rememberMe = false
    
    var body: some View {
        VStack {
            PushButton(title: "Remember me", isOn: $rememberMe)
            Text(rememberMe ? "on" : "off")
                .padding(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
