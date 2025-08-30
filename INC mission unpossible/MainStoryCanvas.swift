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
    @State var money:Int = 0
    @State var Showingfacts:String = ""
    @State var dialogC = 0
    let NpcChillGuyAnimation:Bool = false;
    @State private var chillGuyOffset: CGFloat = -400
    let goToNextHour: () -> Void
    var body: some View {
        NavigationStack{
            VStack{
                VStack{
                    HStack{
                        Spacer()
                        Button("",systemImage: "cloud.sun.fill"){
                            if (Showingfacts == ""){
                                Showingfacts = "Wheather"
                            }else if (Showingfacts == "Wheather"){
                                Showingfacts = ""
                            }
                        }
                        Button("",systemImage: "centsign.bank.building.fill"){
                            if (Showingfacts == ""){
                                Showingfacts = "Money"
                            }else if (Showingfacts == "Money"){
                                Showingfacts = ""
                            }
                        }
                    }
                    HStack{
                        Spacer()
                        var text:String {
                            if (Showingfacts == "Wheather"){
                                return "Partically Cloudy"
                            }else if(Showingfacts == "Money"){
                                return "INCBank: \(money)"
                            }
                            return " "
                        }
                        Text(text)
                    }
                }
                Spacer()
                VStack{
                    if (hoursAfterIncident < 3 && location == 0){
                        ZStack{
                            Image("Bank Entrance").resizable(capInsets: EdgeInsets()).scaledToFit()
                            //Chill guy going in and out of the bank and redrawing money
                            Image("Chill guy").resizable(capInsets: EdgeInsets()).frame(width: 200,height: 200) // control size
                                .offset(x: chillGuyOffset, y: 0)
                                .onAppear {
                                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: true)) {
                                        chillGuyOffset = 400
                                    }
                                }
                        }
                    }
                    else if (hoursAfterIncident == 0){
                        if (hoursAfterIncident == 0){
                            if (location == 2){
                                ZStack{
                                    Image("Bad guys hide out").resizable(capInsets: EdgeInsets()).scaledToFit()
                                    HStack{
                                        Image("Joshua")
                                        Button((dialogC==0) ? "Joshua: I need to get some quick cash." :((dialogC == 1) ? "Joshua: Where do i get it from?": "Joshua: Ahh!! I know I can get some quick cash at the bank.")){
                                            if (dialogC >= 2){
                                                dialogC = -1
                                                goToNextHour()
                                            }
                                            dialogC+=1;
                                        }.frame(width: 175,height:75).background(.blue).clipShape(RoundedRectangle(cornerRadius: 10)).foregroundStyle(.white)
                                    }
                                }                        }
                        }else if(hoursAfterIncident == 1){
                            if (location == 2){
                                ZStack{
                                    Button(action: {
                                        goToNextHour()
                                        goToNextHour()
                                    }) {
                                        Image("2 Hours later meme")
                                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                                            .scaledToFit()
                                    }
                                    
                                }
                            }
                        } else if (hoursAfterIncident == 2){
                            if (location == 2){
                                ZStack{
                                    Button(action: {
                                        goToNextHour()
                                    }) {
                                        Image("2 Hours later meme")
                                            .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                                            .scaledToFit()
                                    }
                                    
                                }
                            }
                        }
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
}
#Preview {
    @Previewable @State var hour:Int = 1
    MainStoryCanvas(hoursAfterIncident:$hour, goToNextHour: {})
}
