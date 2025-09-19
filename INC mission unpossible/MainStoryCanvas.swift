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
    @State private var gunRotation: Double = 0
    @State private var isShooting = false
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
                VStack{
                    Spacer()
                    if (hoursAfterIncident < 3){
                        if (location == 1){
                            ZStack{
                                Image("Bank Entrance").resizable().scaledToFit()
                                Image("VaultClosed").resizable().scaledToFit().scaleEffect(CGFloat(0.65))
                            }
                        }
                    }
                    if (hoursAfterIncident < 3 && location == 0) {
                        ZStack {
                            GeometryReader { geo in
                                let screenWidth = geo.size.width
                                let sceneHeight: CGFloat = 300 // set the height for your scene

                                ZStack {
                                    Image("Bank Entrance")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: screenWidth, height: sceneHeight)
                                        .clipped() // make sure it doesn’t overflow

                                    Image("Chill guy")
                                        .resizable()
                                        .frame(width: 200, height: 200)
                                        .offset(x: chillGuyOffset, y: 0)
                                        .position(x: chillGuyOffset + 100, y: sceneHeight / 2) // center vertically
                                        .onAppear {
                                            chillGuyOffset = -200
                                            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                                                chillGuyOffset = screenWidth + 200
                                            }
                                        }
                                }
                                .frame(width: screenWidth, height: sceneHeight)
                            }
                            .frame(height: 300) // limit GeometryReader height so buttons below are visible
                        }
                    }
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
                            Button(action: {
                                print("E")
                                goToNextHour()
                                goToNextHour()
                            }) {
                                Image("2 Hours later meme")
                                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                                    .scaledToFit()
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
                    } else if (hoursAfterIncident >= 3){
                        if (location == 2){
                            Image("Bad guys hide out")
                                .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                                .scaledToFit()
                        }
                        if (location == 0) {
                            ZStack {
                                // Background
                                Image("Bank Entrance")
                                    .resizable(capInsets: EdgeInsets(), resizingMode: .stretch)
                                    .scaledToFit()

                                // Joshua + Gun
                                VStack {
                                    Spacer() // push to vertical center

                                    ZStack {
                                        Image("Joshua")
                                            .resizable()
                                            .frame(width: 150, height: 150)

                                        Button(action: {
                                        }) {
                                            Text("🔫")
                                                .font(.system(size: 50))
                                                .scaleEffect(x: -1, y: 1)
                                        }
                                        .rotationEffect(.degrees(gunRotation), anchor: UnitPoint(x: 0.1, y: 0.5))
                                        .offset(x: 75, y: 0) // position gun relative to Joshua
                                    }

                                    Spacer() // push to vertical center
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)

                                // Auto-shoot timer
                            }
                            .onAppear {
                                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                    shoot()
                                }
                            }
                        }

                    }
                    Spacer()
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
                        if (location < locations.count){
                            Text("\(locations[location])").multilineTextAlignment(.center)
                        }
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
    func shoot() {
        withAnimation(.easeOut(duration: 0.2)) {
            gunRotation = -20 // rotate slightly upward (like recoil)
        }

        // Reset back after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.2)) {
                gunRotation = 0
            }
        }
    }
}
#Preview {
    @Previewable @State var hour:Int = 0
    MainStoryCanvas(hoursAfterIncident:$hour, goToNextHour: {})
}

