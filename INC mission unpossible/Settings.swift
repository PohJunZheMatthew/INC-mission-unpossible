//
//  Settings.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct Settings: View {
    @State var searchText: String = ""
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    HStack{
                        Image(systemName: "magnifyingglass")
                        TextField("search",text:$searchText)
                    }
                    NavigationLink{
                        Credits()
                    }label : {
                        Text("Credits")
                        Spacer()
                        Image(systemName:"arrowshape.right.fill")
                    }
                }
            }.navigationTitle("Settings")
        }
    }
}

#Preview {
    Settings()
}
