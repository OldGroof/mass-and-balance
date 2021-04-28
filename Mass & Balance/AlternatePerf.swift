//
//  AlternatePerf.swift
//  LPSOLPSOMassBalance
//
//  Created by Jacob Webb on 08/01/2021.
//

import SwiftUI

struct AlternatePerf: View {
    
    @ObservedObject var performance: Calculations
    @ObservedObject var settings = Settings()
    
    var body: some View {
        Form {
            Section() {
                HStack {
                    Text("Alternate Airport")
                        .font(.callout)
                    TextField("ICAO Code", text: $performance.altICAO)
                        .multilineTextAlignment(.trailing)
                        .autocapitalization(.allCharacters)
                }
                HStack {
                    Text("Elevation")
                        .font(.callout)
                    TextField("Elevation", text: $performance.elevAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Air Pressure")
                        .font(.callout)
                    TextField("Pressure", text: $performance.qnhAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Pressure Altitude")
                        .font(.callout)
                    Spacer()
                    Text("\((performance.altAlt), specifier: "%.0f")")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Temperature")
                        .font(.callout)
                    TextField("Temperature", text: $performance.tempAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Wind")
                        .font(.callout)
                    TextField("Wind Comp.", text: $performance.windAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Up Slope")
                        .font(.callout)
                    TextField("Slope", text: $performance.slopeAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading) {
                    Text("Runway Condition")
                        .font(.callout)
                    Picker(selection: $performance.rwyCondAlt, label: Text("Runway Condition")) {
                        Text("Paved Dry").tag(0)
                        Text("Paved Wet").tag(1)
                        Text("Grass Dry").tag(2)
                        Text("Grass Wet").tag(3)
                        }.pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                }
            }
            Section(header: Text("Landing mass: \(performance.altMss, specifier: "%.0f") lbs, C.G: \(performance.altArm, specifier: "%.1f") in.") ) {
                HStack {
                    Text("Landing Distance Required")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        if performance.ldrAlt < 984 {
                            Text("< 300 m")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\(((performance.ldrAlt) * 0.305), specifier: "%.0f") m")
                                .foregroundColor(Color.gray)
                        }
                    } else {
                        if performance.ldrAlt < 1000 {
                            Text("< 1000 ft")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\((performance.ldrAlt), specifier: "%.0f") ft")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                HStack {
                    Text("Landing Distance Required x 1.43")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        if performance.ldrAlt < 984 {
                            Text("< 300 m")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\((((performance.ldrAlt) * 1.43) * 0.305), specifier: "%.0f") m")
                                .foregroundColor(Color.gray)
                        }
                    } else {
                        if performance.ldrAlt < 1000 {
                            Text("< 1000 ft")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\(((performance.ldrAlt) * 1.43), specifier: "%.0f") ft")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
            Section() {
                HStack {
                    Text("Landing Distance Available")
                        .font(.callout)
                    TextField("Distance", text: $performance.ldaAlt)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack {
                    ZStack {
                        GeometryReader { geo in
                            Rectangle()
                                .fill(Color(UIColor.systemGray5))
                            if performance.ldaAlt == "" {
                                Text("Enter Landing Distance Available")
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            } else {
                                if self.$settings.inMeters.wrappedValue == true {
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray4))
                                        .frame(width: (geo.size.width) * CGFloat((performance.ldrAlt * 1.43) * 0.305 / (Double(performance.ldaAlt) ?? 0)))
                                } else {
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray4))
                                        .frame(width: (geo.size.width) * CGFloat((performance.ldrAlt * 1.43) / (Double(performance.ldaAlt) ?? 0)))
                                }
                            }
                        }
                    }.clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(height: 30)
                    HStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(UIColor.systemGray4))
                            .frame(width: 8, height: 8)
                        Text("LDR x 1.43")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Alternate Airport Performance")
    }
}
