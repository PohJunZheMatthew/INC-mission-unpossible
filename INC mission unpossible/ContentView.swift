//
//  ContentView.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//
import SwiftUI

struct ContentView: View {
    @State var incidentStarted = DateComponents(year:2025,month: 8, day: 24)
    @AppStorage("hoursAfterIncindentStarted") var hoursAfterIncindentStarted: Int = 7
    
    var body: some View {
        VStack {
            TabView{
                MainStoryCanvas(hoursAfterIncident: $hoursAfterIncindentStarted).tabItem {
                    Button("Main Camera",systemImage: "camera.fill"){}
                }
                Messages().tabItem{
                    Button("Messages",systemImage: "message"){}
                }
                Settings().tabItem{
                    Button("Settings",systemImage: "gear"){}
                }
            }
            HStack{
                Text("Hrs: \(hoursAfterIncindentStarted)")
                Slider(
                    value: Binding(
                        get: { Double(hoursAfterIncindentStarted) },
                        set: { hoursAfterIncindentStarted = Int($0) }
                    ),
                    in: 7...19
                )
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
