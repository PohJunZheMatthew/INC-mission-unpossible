//
//  MainStoryCanvas.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct MainStoryCanvas: View {
    @Binding var hoursAfterIncident:Int
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    @Previewable @State var hour:Int = 0
    MainStoryCanvas(hoursAfterIncident:$hour)
}
