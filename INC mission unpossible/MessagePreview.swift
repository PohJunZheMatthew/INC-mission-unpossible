//
//  MessagePreview.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct MessagePreview: View {
    @Binding var currentMessage:Message
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd/MM/yyyy"
        return f
    }()
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    HStack{
                        Text("From: \(currentMessage.sender)")
                        Spacer()
                    }
                    Divider()
                    HStack {
                        let calendar = Calendar.current
                        if let date = calendar.date(from: currentMessage.date) {
                            Text("Send at: \(formatter.string(from: date))")
                        } else {
                            Text("Send at: Can't fetch date")
                        }
                        Spacer()
                    }
                    Divider()
                    HStack{
                        Text("Title: \(currentMessage.title)")
                        Spacer()
                    }
                    Divider()
                }.font(.title3)
                Text("  \(currentMessage.description)").font(.title3).alignmentGuide(.leading) { viewDimensions in
                    return 0
                }
                Spacer()
            }.navigationTitle(currentMessage.title)
        }
    }
}

#Preview {
    @Previewable @State var currentMessage:Message = Message(title: "Jonathan's Birthday", date: DateComponents(year: 2025, month: 8, day: 24,hour:10,minute:30), description: "It's Jonathan's birthday and he is going to turn 14 this year. We hope you are able to wish him a happy birthday!", sender: "S2-07")
    MessagePreview(currentMessage: $currentMessage)
}
