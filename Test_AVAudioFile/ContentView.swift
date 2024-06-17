//
//  ContentView.swift
//  Test_AVAudioFile
//
//  Created by Eric Bariaux on 16/06/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Int16 - No Common Format") {
                intFormatNoCommonFormat()
            }
            Button("Float32 - No Common Format") {
                floatFormatNoCommonFormat()
            }
            Button("Int16 - Common Format") {
                intFormatUsingCommonFormat()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
