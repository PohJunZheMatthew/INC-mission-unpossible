//
//  ContentView.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//
import SwiftUI

struct ContentView: View {
    @State var incidentStarted = DateComponents(year:2025,month: 8, day: 24,hour: 7)
    @AppStorage("hoursAfterIncindentStarted") var hoursAfterIncindentStarted: Int = 7
    
    var body: some View {
        VStack {
            TabView{
                MainStoryCanvas(hoursAfterIncident: $hoursAfterIncindentStarted,goToNextHour:{hoursAfterIncindentStarted+=1;}).tabItem {
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
                if let hour = incidentStarted.hour {
                    Text("Hrs: \(hour + hoursAfterIncindentStarted)")
                }
                Slider(
                    value: Binding(
                        get: { Double(hoursAfterIncindentStarted) },
                        set: { hoursAfterIncindentStarted = Int($0) }
                    ),
                    in: 0...12
                )
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
