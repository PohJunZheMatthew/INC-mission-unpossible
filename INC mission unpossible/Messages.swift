//
//  Messages.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI
struct Message:Identifiable{
    var id:UUID = UUID()
    var title:String
    var date:DateComponents
    var description:String
    var sender:String
}
struct Messages: View {
    @State var messages:[Message] = []
    var body: some View {
        NavigationStack{
            VStack{
                if (!messages.isEmpty){
                    List{
                        ForEach(messages){ message in
                            NavigationLink{
                                
                            } label : {
                                Text(message.title)
                                Spacer()
                            }
                        }
                    }
                }else{
                    Text("No messages to read")
                }
            }
        }
    }
}

#Preview {
    Messages()
}
