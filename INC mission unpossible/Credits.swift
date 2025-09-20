//
//  Credits.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 20/9/25.
//

import SwiftUI

struct Credits: View {
    var body: some View {
        NavigationStack{
            VStack{
                Text("This project is made by: ").font(.title2)
                Text("Poh Jun Zhe Matthew").font(.title3)
                Text("Julius Ng").font(.title3)
                Text("Bryan").font(.title3)
                Text("Leo").font(.title3)
                Text("Leeroy").font(.title3)
                Text("Ezekiel").font(.title3)
            }.navigationTitle("Credits")
        }
    }
}

#Preview {
    Credits()
}
