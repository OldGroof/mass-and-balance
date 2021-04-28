//
//  Graph.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 06/11/2020.
//

import SwiftUI

struct Base: View {
    var body: some View {
        GeometryReader { geometry in
                Path { path in
                    // Outline
                    path.move(to: CGPoint(x: (0 + geometry.size.width / 8), y: (geometry.size.height / 2 - 300)))
                    path.addLine(to: CGPoint(x: (0 + geometry.size.width / 8), y: (geometry.size.height / 2 + 300)))
                    path.addLine(to: CGPoint(x: (geometry.size.width - geometry.size.width / 8), y: (geometry.size.height / 2 + 300)))
                    path.addLine(to: CGPoint(x: (geometry.size.width - geometry.size.width / 8), y: (geometry.size.height / 2 - 300)))
                    path.addLine(to: CGPoint(x: (0 + geometry.size.width / 8), y: (geometry.size.height / 2 - 300)))
                    path.closeSubpath()
                    
                    //Adding Details
                    path.move(to: CGPoint(x: (0 + geometry.size.width / 8), y: (geometry.size.height / 2 + 250)))
                    path.addLine(to: CGPoint(x: ((geometry.size.width) - geometry.size.width / 8), y: (geometry.size.height / 2 + 250)))
                    path.closeSubpath()
                    
                    //CG Envelope
                    path.move(to: CGPoint(x: ((geometry.size.width - geometry.size.width / 5) - (geometry.size.width * 0.028)), y: (geometry.size.height / 2 + 250)))
                    path.addLine(to: CGPoint(x: ((geometry.size.width - geometry.size.width / 5) - (geometry.size.width * 0.028)), y: (geometry.size.height / 2 - 275)))
                    path.addLine(to: CGPoint(x: ((geometry.size.width / 2) + (geometry.size.width * 0.04)), y: (geometry.size.height / 2 - 275)))
                    path.addLine(to: CGPoint(x: ((0 + geometry.size.width / 5) - (geometry.size.width * 0.005)), y: (geometry.size.height / 2 - 125)))
                    path.addLine(to: CGPoint(x: ((0 + geometry.size.width / 5) - (geometry.size.width * 0.005)), y: (geometry.size.height / 2 + 250)))
                    path.closeSubpath()
                    
                }
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            ZStack {
                VStack {
                    ZStack {
                        VStack {
                            ForEach(Array(stride(from: 1200, to: 2600, by: 100)).reversed(), id: \.self) {
                                Text("\($0)")
                                    .font(.footnote)
                                    .background(Color(UIColor.systemBackground))
                                    .position(x: (((geometry.size.width / 8) * 6) - 25), y: 40)
                            }
                        }.frame(width: ((geometry.size.width / 8) * 6), height: 546)
                    }
                    HStack {
                        ForEach(0..<12) { cog in
                            Text("\(cog + 82)")
                                .font(.footnote)
                            Spacer()
                            }
                    }.frame(width: ((geometry.size.width / 8) * 5), height: 25)
                        Text("C.G. Location")
                            .font(.caption)
                    
                }.position(x: (geometry.size.width / 2), y: (((geometry.size.height) / 2) - 5))
                Text("Airplane Weight")
                    .font(.caption)
                    .background(Color(UIColor.systemBackground))
                    .rotationEffect(Angle(degrees: 270))
                    .position(x: ((geometry.size.width - geometry.size.width / 5) + 2), y: geometry.size.height / 2)
            }
            .navigationBarTitle("C.G. Range and Weight")
        }
    }
}

struct Tom: View {
    
    var tom:Double
    var tArm:Double
    
   var body: some View {
        GeometryReader { geometry in
            let envTop = geometry.size.height / 2 - 275
            let envMin = (0 + geometry.size.width / 5) - (geometry.size.width * 0.005)
            let envMax = (geometry.size.width - geometry.size.width / 5) - (geometry.size.width * 0.028)
            let idk = ((envMax - envMin) / 11) * CGFloat(((tArm) - 82))

            let X = envMin + idk
            let Y = Double(envTop) + ((525 / 1350) * (2550 - tom))
            Text("X")
                .position(x: CGFloat(X), y: CGFloat(Y))
                .foregroundColor(Color.red)
        }
    }
}

struct Lm: View {
    
    var lm:Double
    var lArm:Double
    
   var body: some View {
        GeometryReader { geometry in
            let envTop = geometry.size.height / 2 - 275
            let envMin = (0 + geometry.size.width / 5) - (geometry.size.width * 0.005)
            let envMax = (geometry.size.width - geometry.size.width / 5) - (geometry.size.width * 0.028)
            let idk = ((envMax - envMin) / 11) * CGFloat(((lArm) - 82))

            let X = envMin + idk
            let Y = Double(envTop) + ((525 / 1350) * (2550 - lm))
            Text("X")
                .position(x: CGFloat(X), y: CGFloat(Y))
                .foregroundColor(Color.green)
                
        }
    }
}

struct Zfm: View {
    
    var zfm:Double
    var zArm:Double
    
   var body: some View {
        GeometryReader { geometry in
            let envTop = geometry.size.height / 2 - 275
            let envMin = (0 + geometry.size.width / 5) - (geometry.size.width * 0.005)
            let envMax = (geometry.size.width - geometry.size.width / 5) - (geometry.size.width * 0.028)
            let idk = ((envMax - envMin) / 11) * CGFloat(((zArm) - 82))

            let X = envMin + idk
            let Y = Double(envTop) + ((525 / 1350) * (2550 - zfm))
            Text("X")
                .position(x: CGFloat(X), y: CGFloat(Y))
        }
    }
}

struct GraphSession: View {
    var zMss, zArm, tMss, tArm, lMss, lArm:Double
    var body: some View {
        ZStack {
            Tom(tom: tMss, tArm: tArm)
            Lm(lm: lMss, lArm: lArm)
            Zfm(zfm: zMss, zArm: zArm)
            Base()
        }
    }
}

struct Graph: View {
    
    @ObservedObject var performance: Calculations
    
    var body: some View {
        ZStack {
            Tom(tom: performance.tomMss, tArm: performance.tomArm)
            Lm(lm: performance.lmMss, lArm: performance.lmArm)
            Zfm(zfm: performance.zfmMss, zArm: performance.zfmArm)
            Base()
        }
    }
}
