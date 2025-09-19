//
//  ContentView.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct ContentView: View {
    @State var incidentStarted = DateComponents(year:2025,month: 8, day: 24,hour: 7)
    @AppStorage("hoursAfterIncindentStarted") var hoursAfterIncindentStarted: Int = 0
    @State var MessagesInTheStory:[Message] = [
        Message(title: "Hint 1", date: DateComponents(year: 2025, month: 8, day: 24,hour:7,minute:1), description: "There is something going on at the bad guys hide out.", sender: "Anonymous"),
        Message(title: "Bank Alert", date: DateComponents(year: 2025, month: 8, day: 24,hour:10,minute:1), description: "Joshua is robbing the bank right now! Switch to the bank first camera!", sender: "Security System"),
        Message(title: "Vault Breach", date: DateComponents(year: 2025, month: 8, day: 24,hour:12,minute:1), description: "Joshua has entered the bank vault! Switch to the bank second camera!", sender: "Security System"),
        Message(title: "Police Dispatch", date: DateComponents(year: 2025, month: 8, day: 24,hour:11,minute:30), description: "Units responding to bank robbery in progress. Officer Kesler en route.", sender: "Police Dispatch"),
        Message(title: "Witness Report", date: DateComponents(year: 2025, month: 8, day: 24,hour:10,minute:45), description: "Shots fired at First National Bank. Multiple casualties reported.", sender: "911 Caller"),
        Message(title: "Breaking News", date: DateComponents(year: 2025, month: 8, day: 24,hour:13,minute:15), description: "BREAKING: Suspect arrested after dramatic bank vault confrontation!", sender: "News Channel 7"),
        Message(title: "Court Notice", date: DateComponents(year: 2025, month: 8, day: 24,hour:17,minute:0), description: "Court proceedings scheduled for suspect Joshua. Case #2025-BR-001", sender: "Court System"),
        Message(title: "Final Update", date: DateComponents(year: 2025, month: 8, day: 24,hour:18,minute:30), description: "Suspect found guilty. Sentenced to prison. Case closed.", sender: "Justice Department")
    ]
    @State var messages: [Message] = []
    @State var unreadMessageCount: Int = 0
    @State var lastReadCount: Int = 0
    
    var body: some View {
        VStack {
            TabView{
                MainStoryCanvas(hoursAfterIncident: $hoursAfterIncindentStarted,goToNextHour:{
                    hoursAfterIncindentStarted += 1
                    checkForNewMessagesC()
                }).tabItem {
                    Button("Main Camera",systemImage: "camera.fill"){}
                }
                
                if unreadMessageCount > 0 {
                    Messages(messages: $messages).tabItem{
                        Button("Messages",systemImage: "message"){
                            markMessagesAsReadC()
                        }
                    }
                    .badge(unreadMessageCount)
                } else {
                    Messages(messages: $messages).tabItem{
                        Button("Messages",systemImage: "message"){
                            markMessagesAsReadC()
                        }
                    }
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
                        set: {
                            hoursAfterIncindentStarted = Int($0)
                            checkForNewMessagesC()
                        }
                    ),
                    in: 0...12,
                    step: 1
                )
            }
        }
        .onChange(of: hoursAfterIncindentStarted){
            print("New Value: \(hoursAfterIncindentStarted)")
            checkForNewMessagesC()
        }
        .onAppear {
            checkForNewMessagesC()
        }
        .padding()
    }
    
    private func checkForNewMessagesC() {
        let previousMessageCount = messages.count
        
        // Hour 0 - Initial hint
        if hoursAfterIncindentStarted >= 0 {
            addMessageIfNotExistsC(MessagesInTheStory[0])
        }
        
        // Hour 3 - Bank activity starts
        if hoursAfterIncindentStarted >= 3 {
            addMessageIfNotExistsC(MessagesInTheStory[1])
        }
        
        // Hour 4 - Shooting incident
        if hoursAfterIncindentStarted >= 4 {
            addMessageIfNotExistsC(MessagesInTheStory[4])
        }
        
        // Hour 5 - Police dispatch
        if hoursAfterIncindentStarted >= 5 {
            addMessageIfNotExistsC(MessagesInTheStory[3])
        }
        
        // Hour 6 - Vault breach
        if hoursAfterIncindentStarted >= 6 {
            addMessageIfNotExistsC(MessagesInTheStory[2])
        }
        
        // Hour 9 - Breaking news
        if hoursAfterIncindentStarted >= 9 {
            addMessageIfNotExistsC(MessagesInTheStory[5])
        }
        
        // Hour 11 - Court notice
        if hoursAfterIncindentStarted >= 11 {
            addMessageIfNotExistsC(MessagesInTheStory[6])
        }
        
        // Hour 12 - Final update
        if hoursAfterIncindentStarted >= 12 {
            addMessageIfNotExistsC(MessagesInTheStory[7])
        }
        
        // Update unread count
        let newMessageCount = messages.count - previousMessageCount
        if newMessageCount > 0 {
            unreadMessageCount += newMessageCount
        }
    }
    
    private func addMessageIfNotExistsC(_ message: Message) {
        if !messages.contains(where: { $0.id == message.id }) {
            messages.append(message)
        }
    }
    
    private func markMessagesAsReadC() {
        unreadMessageCount = 0
    }
}

#Preview {
    ContentView()
}
