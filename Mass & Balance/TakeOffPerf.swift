//
//  TakeOffPerf.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 16/11/2020.
//

import SwiftUI

struct SelectedAirport {
    var icao: String?
    var name: String?
    var elevation: Int?
    var runways: [Runway]?
    
    init(icao: String? = nil, name: String? = nil, elevation: Int? = nil, runways: [Runway]? = nil) {
        self.icao = icao
        self.name = name
        self.elevation = elevation
        self.runways = runways
    }
}


struct TakeOffPerf: View {
    @ObservedObject var airports = LoadAirport()
    @ObservedObject var performance: Calculations
    @ObservedObject var settings = Settings()
    
    @State var selAirport = SelectedAirport()
    
    @State var rwySelected = ""
    
    var body: some View {
        Form {
            Section() {
                HStack {
                    Text("Airport")
                        .font(.callout)
                    Spacer()
                    Menu {
                        ForEach(airports.json) { airport in
                            Button(action: {
                                selAirport = SelectedAirport(icao: airport.icao, name: airport.name, elevation: airport.elevation, runways: airport.runways)
                                performance.elevDep = String(selAirport.elevation ?? 0)
                                performance.tora = ""
                                performance.toda = ""
                                performance.asda = ""
                                rwySelected = ""
                            }) {
                                Text("\(airport.icao) - \(airport.name)")
                            }
                        }
                        Button(action: {
                            selAirport = SelectedAirport()
                            performance.elevDep = String(selAirport.elevation ?? 0)
                            performance.tora = ""
                            performance.toda = ""
                            performance.asda = ""
                            rwySelected = ""
                        }) {
                            Text("Clear")
                        }
                    } label: {
                        if selAirport.icao == nil {
                            Text("Select Airport")
                                .frame(width: 200, alignment: .trailing)
                        } else {
                            Text("\(selAirport.icao ?? "") - \(selAirport.name ?? "")")
                                .frame(width: 200, alignment: .trailing)
                        }
                    }.frame(width: 200, alignment: .trailing)
                }
                if selAirport.icao == nil {
                    
                } else {
                    HStack {
                        Text("Runway")
                        Spacer()
                        Menu {
                            ForEach(selAirport.runways!) { runway in
                                Button(action: {
                                    rwySelected = runway.name
                                    performance.tora = String(runway.tora)
                                    performance.toda = String(runway.toda)
                                    performance.asda = String(runway.asda)
                                }) {
                                    Text(runway.name)
                                }
                            }
                        } label: {
                            if rwySelected == "" {
                                Text("Select Runway")
                                    .frame(width: 150, alignment: .trailing)
                            } else {
                                Text("Runway \(rwySelected)")
                                    .frame(width: 150, alignment: .trailing)
                            }
                        }.frame(width: 150, alignment: .trailing)
                    }
                }
            }
            Section() {
                HStack {
                    Text("Flaps 25°")
                        .font(.callout)
                    Spacer()
                    Toggle("", isOn: $performance.flaps)
                }
                HStack {
                    Text("Elevation")
                        .font(.callout)
                    TextField("Elevation", text: $performance.elevDep)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Air Pressure")
                        .font(.callout)
                    TextField("Pressure", text: $performance.qnhDep)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Pressure Altitude")
                        .font(.callout)
                    Spacer()
                    Text("\((performance.altDep), specifier: "%.0f")")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Temperature")
                        .font(.callout)
                    TextField("Temperature", text: $performance.tempDep)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Wind")
                        .font(.callout)
                    TextField("Wind Comp.", text: $performance.windDep)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Up Slope")
                        .font(.callout)
                    TextField("Slope", text: $performance.slopeDep)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading) {
                    Text("Runway Condition")
                        .font(.callout)
                    Picker(selection: $performance.rwyCondDep, label: Text("Runway Condition")) {
                            Text("Paved").tag(0)
                            Text("Grass Dry").tag(1)
                            Text("Grass Wet").tag(2)
                        }.pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                }
            }
            Section(header: Text("Take off mass: \(performance.tomMss, specifier: "%.0f") lbs, C.G: \(performance.tomArm, specifier: "%.1f") in.")) {
                HStack {
                    Text("Ground Roll")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        Text("\((performance.groundRoll * 0.305), specifier: "%.0f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("\((performance.groundRoll), specifier: "%.0f") ft")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Text("Take off Distance Required")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        Text("\((performance.todr * 0.305), specifier: "%.0f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("\((performance.todr), specifier: "%.0f") ft")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Text("Take off Distance Required x 1.25")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        Text("\(((performance.todr * 1.25) * 0.305), specifier: "%.0f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("\((performance.todr * 1.25), specifier: "%.0f") ft")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Text("Take off Distance Required x 1.15")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        Text("\(((performance.todr * 1.15) * 0.305), specifier: "%.0f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("\((performance.todr * 1.15), specifier: "%.0f") ft")
                            .foregroundColor(.gray)
                    }
                }
                HStack {
                    Text("Take off Distance Required x 1.30")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        Text("\(((performance.todr * 1.3) * 0.305), specifier: "%.0f") m")
                            .foregroundColor(.gray)
                    } else {
                        Text("\((performance.todr * 1.3), specifier: "%.0f") ft")
                            .foregroundColor(.gray)
                    }
                }
            }
            Section() {
                HStack {
                    Text("Take off Run Available")
                        .font(.callout)
                    Text("If runway is balanced only enter TORA")
                        .font(.subheadline)
                        .foregroundColor(Color.gray)
                    TextField("Distance", text: $performance.tora)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Take off Distance Available")
                        .font(.callout)
                    TextField("Distance", text: $performance.toda)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Accelerate Stop Distance Available")
                        .font(.callout)
                    TextField("Distance", text: $performance.asda)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack {
                    ZStack {
                        GeometryReader { geo in
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(UIColor.systemGray5))
                            if performance.tora == "" {
                                Text("Enter Take off Run Available")
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            } else if performance.toda == "" {
                                if self.$settings.inMeters.wrappedValue == true {
                                    Rectangle()
                                        .fill(Color(UIColor.systemBlue))
                                        .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.25) * 0.305 / (Double(performance.tora) ?? 0)))
                                    Rectangle()
                                        .fill(Color(UIColor.systemTeal))
                                        .frame(width: (geo.size.width) * CGFloat((performance.todr * 0.305) / (Double(performance.tora) ?? 0)))
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray2))
                                        .frame(width: (geo.size.width) * CGFloat((performance.groundRoll * 0.305) / (Double(performance.tora) ?? 0)))
                                } else {
                                    Rectangle()
                                        .fill(Color(UIColor.systemBlue))
                                        .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.25) / (Double(performance.tora) ?? 0)))
                                    Rectangle()
                                        .fill(Color(UIColor.systemTeal))
                                        .frame(width: (geo.size.width) * CGFloat((performance.todr) / (Double(performance.tora) ?? 0)))
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray2))
                                        .frame(width: (geo.size.width) * CGFloat((performance.groundRoll) / (Double(performance.tora) ?? 0)))
                                }
                            } else {
                                if self.$settings.inMeters.wrappedValue == true {
                                    VStack(alignment: .leading) {
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color(UIColor.systemTeal))
                                                .frame(width: (geo.size.width) * CGFloat(performance.todr * 0.305 / (Double(performance.tora) ?? 0)), height: 10)
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray2))
                                                .frame(width: (geo.size.width) * CGFloat(performance.groundRoll * 0.305 / (Double(performance.tora) ?? 0)), height: 10)
                                        }
                                        Rectangle()
                                            .fill(Color(UIColor.systemBlue))
                                            .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.15) * 0.305 / (Double(performance.toda) ?? 0)), height: 10)
                                        .padding(.vertical, -8)
                                        Rectangle()
                                            .fill(Color(UIColor.systemIndigo))
                                            .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.3) * 0.305 / (Double(performance.asda) ?? 0)), height: 10)
                                            .padding(.vertical, -6)
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        ZStack(alignment: .leading) {
                                            Rectangle()
                                                .fill(Color(UIColor.systemTeal))
                                                .frame(width: (geo.size.width) * CGFloat(performance.todr / (Double(performance.tora) ?? 0)), height: 10)
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray2))
                                                .frame(width: (geo.size.width) * CGFloat(performance.groundRoll / (Double(performance.tora) ?? 0)), height: 10)
                                        }
                                        Rectangle()
                                            .fill(Color(UIColor.systemBlue))
                                            .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.15) / (Double(performance.toda) ?? 0)), height: 10)
                                            .padding(.vertical, -8)
                                        Rectangle()
                                            .fill(Color(UIColor.systemIndigo))
                                            .frame(width: (geo.size.width) * CGFloat((performance.todr * 1.3) / (Double(performance.asda) ?? 0)), height: 10)
                                            .padding(.vertical, -6)
                                    }
                                }
                            }
                        }
                    }.clipShape(RoundedRectangle(cornerRadius: 5))
                    .frame(height: 30)
                    if performance.tora == "" {
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray4))
                                .frame(width: 8, height: 8)
                            Text("TODR")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray4))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.15")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray3))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.25")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray2))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.30")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    } else if performance.toda == "" {
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray2))
                                .frame(width: 8, height: 8)
                            Text("Ground Roll")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemTeal))
                                .frame(width: 8, height: 8)
                            Text("TODR")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemBlue))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.25")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    } else {
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray2))
                                .frame(width: 8, height: 8)
                            Text("Ground Roll")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemTeal))
                                .frame(width: 8, height: 8)
                            Text("TODR")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemBlue))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.15")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemIndigo))
                                .frame(width: 8, height: 8)
                            Text("TODR x 1.30")
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Take off Performance")
    }
}
