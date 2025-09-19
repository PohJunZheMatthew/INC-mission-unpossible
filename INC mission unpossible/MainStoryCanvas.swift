//
//  MainStoryCanvas.swift
//  INC mission unpossible
//
//  Created by Poh Jun Zhe Matthew on 25/8/25.
//

import SwiftUI

struct ChillGuyNPC: View {
    @State private var xOffset: CGFloat = 150
    @State private var yOffset: CGFloat = 150
    @State private var isDead: Bool = false
    @State private var isHit: Bool = false
    @State private var bloodSplatter: Bool = false
    let id: Int

    var body: some View {
        ZStack {
            Image("Chill guy")
                .resizable()
                .frame(width: 100, height: 100)
                .offset(x: xOffset, y: 75)
                .rotationEffect(.degrees(isDead ? 90 : 0))
                .opacity(isDead ? 0.7 : 1.0)
                .scaleEffect(isHit ? 1.2 : 1.0)
                .onAppear {
                    yOffset = CGFloat(id * 110) - 50 // stack vertically around center
                    withAnimation(.linear(duration: 2).repeatForever(autoreverses: true)) {
                        xOffset = 0 // remain centered horizontally
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .init("ChillGuyShot"))) { notification in
                    if let shotId = notification.object as? Int, shotId == id {
                        getShot()
                    }
                }

            if bloodSplatter {
                Text("💥")
                    .font(.system(size: 50))
                    .foregroundColor(.red)
                    .offset(x: xOffset, y: yOffset - 10)
            }
        }
    }

    private func getShot() {
        withAnimation(.easeOut(duration: 0.1)) {
            isHit = true
            bloodSplatter = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.8)) {
                isDead = true
                isHit = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            bloodSplatter = false
        }
    }
}


struct PoliceOfficer: View {
    @State private var isVisible: Bool = false
    
    var body: some View {
        Image("Police")
            .resizable()
            .frame(width: 120, height: 120)
            .offset(x: -200, y: 30)
            .opacity(isVisible ? 1.0 : 0.0)
            .onAppear {
                withAnimation(.easeIn(duration: 1.0).delay(2.0)) {
                    isVisible = true
                }
            }
    }
}

struct MainStoryCanvas: View {
    @Binding var hoursAfterIncident: Int
    @State var locationsL: [String] = ["Bank first camera", "Bank second camera", "Bad guys hideout", "Police Station", "Courthouse"]
    @AppStorage("location") var locationC: Int = 0
    @State var dialogC = 0
    @State var chillGuysC = 1
    @State var policeArrivedC = false
    @State var keslerArrestedC = false
    @State var evidenceFoundC = false
    let goToNextHour: () -> Void
    @State private var gunRotationC: Double = 0
    @State private var muzzleFlashC = false
    @State private var gunSmokeC = false
    @State private var shellCasingC = false
    @State private var gunAngleC: Double = 0
    @State private var targetedChillGuyC = 0
    @State private var chillGuyPositionsC: [CGPoint] = []
    @State private var showExplosionC = false
    @State private var vaultOpenC = false
    @State private var moneyTakenC = false
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                if hoursAfterIncident == 0 && locationC == 2 {
                    badGuysPlanningScene()
                } else if hoursAfterIncident == 1 && locationC == 2 {
                    timeSkipScene()
                } else if hoursAfterIncident == 2 && locationC == 2 {
                    timeSkipScene()
                } else if hoursAfterIncident >= 3 && hoursAfterIncident <= 5 && locationC == 0 {
                    if hoursAfterIncident == 3 {
                        bankWithMovingChillGuys()
                    } else if hoursAfterIncident == 4 {
                        joshuaShootsChillGuy()
                    } else {
                        policeArrivalScene()
                    }
                } else if hoursAfterIncident == 6 && locationC == 1 {
                    vaultClosedScene()
                } else if hoursAfterIncident == 7 && locationC == 1 {
                    vaultBreachingScene()
                } else if hoursAfterIncident == 8 && locationC == 1 {
                    keslerConfrontationScene()
                } else if hoursAfterIncident == 9 && locationC == 1 {
                    shootoutScene()
                } else if hoursAfterIncident == 10 && locationC == 3 {
                    policeStationScene()
                } else if hoursAfterIncident == 11 && locationC == 4 {
                    courtroomScene()
                } else if hoursAfterIncident >= 12 && locationC == 4 {
                    endingScene()
                } else {
                    defaultBackgroundScene()
                }
            }
            Spacer()
            locationControlsV
        }
    }
    
    @ViewBuilder
    private func defaultBackgroundScene() -> some View {
        ZStack {
            if locationC == 0 {
                Image("Bank Entrance").resizable().scaledToFit()
                if hoursAfterIncident >= 3 && hoursAfterIncident <= 5 {
                    ForEach(0..<chillGuysC, id: \.self) { index in
                        ChillGuyNPC(id: index)
                    }
                }
            } else if locationC == 1 {
                Image("VaultClosed").resizable().scaledToFit()
            } else if locationC == 2 {
                Image("Bad guys hide out").resizable().scaledToFit()
                VStack {
                    Spacer()
                    Text("Joshua is not here right now...")
                        .padding()
                        .background(.gray.opacity(0.8))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else if locationC == 3 {
                Image("PoliceStation").resizable().scaledToFit()
            } else if locationC == 4 {
                Image("Courtroom").resizable().scaledToFit()
            }
        }
    }
    
    @ViewBuilder
    private func badGuysPlanningScene() -> some View {
        ZStack {
            Image("Bad guys hide out").resizable().scaledToFit()
            VStack {
                Image("Joshua")
                Button(dialogTextC) {
                    if dialogC >= 2 {
                        dialogC = -1
                        goToNextHour()
                    }
                    dialogC += 1
                }
                .frame(width: 250, height: 75)
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func timeSkipScene() -> some View {
        Button(action: {
            let hoursToSkip = max(0, 3 - hoursAfterIncident)
            for _ in 0..<hoursToSkip {
                goToNextHour()
            }
        }) {
            Image("2 Hours later meme")
                .resizable()
                .scaledToFit()
        }
    }
    
    @ViewBuilder
    private func bankWithMovingChillGuys() -> some View {
        ZStack {
            Image("Bank Entrance").resizable().scaledToFit()
            ForEach(0..<chillGuysC, id: \.self) { index in
                ChillGuyNPC(id: index)
            }
            if hoursAfterIncident == 3 {
                VStack {
                    Spacer()
                    Button("Chill Guys: Just another normal day at the bank...") {
                        goToNextHour()
                    }
                    .frame(width: 350, height: 75)
                    .background(.cyan)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            } else {
                VStack {
                    Spacer()
                    Button("Joshua: Perfect, some innocent people to intimidate...") {
                        goToNextHour()
                    }
                    .frame(width: 350, height: 75)
                    .background(.red)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
    }
    
    @ViewBuilder
    private func joshuaShootsChillGuy() -> some View {
        ZStack {
            Image("Bank Entrance").resizable().scaledToFit()
            
            ForEach(0..<chillGuysC, id: \.self) { index in
                ChillGuyNPC(id: index)
            }
            
            VStack {
                Spacer()
                
                HStack(alignment: .center) {
                    ZStack {
                        Image("Joshua")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .scaleEffect(x: -1, y: 1).offset(x:0,y:-125)
                        Text("🔫")
                            .rotationEffect(.degrees(gunAngleC)).scaleEffect(2)
                            .offset(x: -90, y: -125).scaleEffect(x:-1,y:1)
                        
                        if muzzleFlashC {
                            Text("🔥")
                                .font(.title2)
                                .foregroundColor(.yellow).scaleEffect(2)
                                .offset(x: 100, y: -130)
                        }
                        
                        if gunSmokeC {
                            Text("💨")
                                .font(.title3)
                                .foregroundColor(.gray).scaleEffect(2)
                                .offset(x: 100, y: -130)
                        }
                        
                        if shellCasingC {
                            Text("✨")
                                .font(.caption)
                                .foregroundColor(.orange).scaleEffect(2)
                                .offset(x: 100, y: -130)
                        }
                    }.offset(x:-10,y:50)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                
                Button("Joshua: Everyone on the ground! *BANG*") {
                    shootActionC()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        goToNextHour()
                    }
                }
                .frame(width: 350, height: 75)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func policeArrivalScene() -> some View {
        ZStack {
            Image("Bank Entrance").resizable().scaledToFit()
            VStack {
                Image("Joshua").resizable().frame(width: 150, height: 150)
                Button("Joshua: Oh no, the police are coming!") {
                    policeArrivedC = true
                    goToNextHour()
                }
                .frame(width: 350, height: 75)
                .background(.orange)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            if policeArrivedC {
                PoliceOfficer()
            }
        }
    }
    
    @ViewBuilder
    private func vaultClosedScene() -> some View {
        VStack {
            Image("VaultClosed").resizable().scaledToFit()
            Button("Joshua: Time to crack this vault open...") {
                goToNextHour()
            }
            .frame(width: 350, height: 75)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    @ViewBuilder
    private func vaultBreachingScene() -> some View {
        ZStack {
            Image(vaultOpenC ? "VaultOpen" : "VaultClosed").resizable().scaledToFit()
            
            if showExplosionC {
                Text("💥")
                    .font(.system(size: 100))
                    .opacity(showExplosionC ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5), value: showExplosionC)
            }
            
            VStack {
                Spacer()
                Button("Joshua: Stand back!") {
                    withAnimation {
                        showExplosionC = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        vaultOpenC = true
                        showExplosionC = false
                        goToNextHour()
                    }
                }
                .frame(width: 300, height: 75)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func keslerConfrontationScene() -> some View {
        ZStack {
            Image("VaultOpen").resizable().scaledToFit()
            VStack {
                HStack {
                    Image("Joshua").resizable().frame(width: 120, height: 120)
                    Spacer()
                    Image("Kesler").resizable().frame(width: 120, height: 120)
                }
                Spacer()
                Button(keslerDialogC) {
                    if dialogC >= 3 {
                        dialogC = 0
                        goToNextHour()
                    } else {
                        dialogC += 1
                    }
                }
                .frame(width: 350, height: 75)
                .background(.green)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func shootoutScene() -> some View {
        ZStack {
            Image("VaultOpen").resizable().scaledToFit()
            VStack {
                HStack {
                    VStack {
                        Image("Joshua").resizable().frame(width: 120, height: 120)
                        Text("🔫").font(.title).scaleEffect(x:-1,y:1)
                    }
                    Spacer()
                    VStack {
                        Image("Kesler").resizable().frame(width: 120, height: 120)
                        Text("🔫").font(.title)
                    }
                }
                Spacer()
                Button("Final Showdown - Joshua is arrested!") {
                    keslerArrestedC = false
                    evidenceFoundC = true
                    goToNextHour()
                }
                .frame(width: 350, height: 75)
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func policeStationScene() -> some View {
        ZStack {
            Image("Police station").resizable().scaledToFit()
            VStack {
                Image("Joshua").resizable().frame(width: 150, height: 150).grayscale(1.0)
                Button("Joshua: I demand a lawyer!") {
                    goToNextHour()
                }
                .frame(width: 300, height: 75)
                .background(.gray)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func courtroomScene() -> some View {
        ZStack {
            Image("Courtroom").resizable().scaledToFit()
            VStack {
                HStack {
                    Image("Judge").resizable().frame(width: 100, height: 100)
                    Image("Joshua").resizable().frame(width: 100, height: 100)
                    Image("Kesler").resizable().frame(width: 100, height: 100)
                }
                Button("Judge: Joshua, you are guilty of bank robbery!") {
                    goToNextHour()
                }
                .frame(width: 400, height: 75)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    @ViewBuilder
    private func endingScene() -> some View {
        ZStack {
            Image("Prison").resizable().scaledToFit()
            VStack {
                Image("Joshua").resizable().frame(width: 150, height: 150).grayscale(1.0)
                Text("THE END")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(.black.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                Button("Joshua: I should have chosen a different career...") {
                    hoursAfterIncident = 0
                    locationC = 0
                    dialogC = 0
                    chillGuysC = 1
                    policeArrivedC = false
                    keslerArrestedC = false
                    evidenceFoundC = false
                    vaultOpenC = false
                    moneyTakenC = false
                }
                .frame(width: 400, height: 75)
                .background(.purple)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    private var dialogTextC: String {
        switch dialogC {
        case 0: return "Joshua: I need to get some quick cash."
        case 1: return "Joshua: Where do I get it from?"
        default: return "Joshua: Ahh!! I know, the bank!"
        }
    }
    
    private var keslerDialogC: String {
        switch dialogC {
        case 0: return "Kesler: Freeze, Joshua!"
        case 1: return "Joshua: You'll never take me alive!"
        case 2: return "Kesler: Drop your weapon!"
        default: return "Joshua: Never!"
        }
    }
    
    private var locationControlsV: some View {
        HStack {
            Button { changeLocationC(-1) } label: { Image(systemName: "arrowshape.left.fill") }
            Spacer()
            Text("\(locationsL[locationC])")
                .frame(width: 175, height: 50)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
            Spacer()
            Button { changeLocationC(1) } label: { Image(systemName: "arrowshape.right.fill") }
        }
        .padding()
    }
    
    private func changeLocationC(_ deltaC: Int) {
        locationC = (locationC + deltaC + locationsL.count) % locationsL.count
    }
    
    private func initializePositionsC() {
        chillGuyPositionsC = Array(repeating: CGPoint.zero, count: max(chillGuysC, 2))
    }
    
    private func updateChillGuyPositionC(id: Int, x: CGFloat, y: CGFloat) {
        while chillGuyPositionsC.count <= id {
            chillGuyPositionsC.append(CGPoint.zero)
        }
        chillGuyPositionsC[id] = CGPoint(x: x, y: y)
        updateGunAngleC()
    }

    private func updateGunAngleC() {
        guard chillGuysC > 0 && targetedChillGuyC < chillGuyPositionsC.count else { return }
        
        let targetIndex = targetedChillGuyC % chillGuysC
        guard targetIndex < chillGuyPositionsC.count else { return }
        
        let targetPos = chillGuyPositionsC[targetIndex]
        let joshuaPos = CGPoint(x: -150, y: 50) // Joshua is now at left side
        
        let deltaX = targetPos.x - joshuaPos.x
        let deltaY = targetPos.y - joshuaPos.y
        
        gunAngleC = atan2(deltaY, deltaX) * 180 / .pi
    }
    private func shootActionC() {
        if chillGuysC > 0 {
            let targetId = targetedChillGuyC % chillGuysC
            NotificationCenter.default.post(name: .init("ChillGuyShot"), object: targetId)
            chillGuysC -= 1
            targetedChillGuyC += 1
            updateGunAngleC()
        }
        realisticShootAnimationC()
    }
    
    private func realisticShootAnimationC() {
        withAnimation(.easeOut(duration: 0.05)) {
            gunRotationC = -25
            muzzleFlashC = true
            shellCasingC = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.1)) {
                muzzleFlashC = false
                gunSmokeC = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeIn(duration: 0.3)) {
                gunRotationC = 0
                shellCasingC = false
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.5)) {
                gunSmokeC = false
            }
        }
    }
}

#Preview {
    @Previewable @State var hourC: Int = 3
    MainStoryCanvas(hoursAfterIncident: $hourC, goToNextHour: {})
}
