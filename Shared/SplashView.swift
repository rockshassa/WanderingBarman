//
//  ContentView.swift
//  Shared
//
//  Created by Nick on 12/3/20.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("FOXHOLE")
                .multilineTextAlignment(.center)
                .font(.headline)
            
            Text("drinks to you within the hour\n5-10pm daily\n$30 minimum").italic()
                .multilineTextAlignment(.center)
                .padding()
                .font(.subheadline)
                
            Spacer()
            Button("Enter") {
                
            }
            Spacer()
        }
    }
    
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
