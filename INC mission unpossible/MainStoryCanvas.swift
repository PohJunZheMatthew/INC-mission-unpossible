//
//  MainStoryCanvas.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct MainStoryCanvas: View {
    @Binding var hoursAfterIncident:Int
    @State var locations: [String] = ["Bank first camera","Bank second camera", "Bad guys hideout"]
    @AppStorage("location") var location:Int = 0
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    HStack{
                        Spacer()
                        Button("",systemImage: "cloud.sun.fill"){}
                    }
                }
                Spacer()
                VStack{
                    Image("Joshua")
                }
                Spacer()
                HStack{
                    Spacer()
                    Button("",systemImage: "arrowshape.left.fill"){
                        location -= 1
                        if location < 0{
                            location = locations.count - 1
                        }
                    }
                    Spacer()
                    VStack{
                        Text("\(locations[location])").multilineTextAlignment(.center)
                    }.frame(width:175,height:50).background(.white).clipShape(RoundedRectangle(cornerRadius: 10)).shadow(radius: 10)
                    Spacer()
                    Button("",systemImage: "arrowshape.right.fill"){
                        location += 1
                        if location > locations.count-1 {
                            location = 0
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var hour:Int = 0
    MainStoryCanvas(hoursAfterIncident:$hour)
}
