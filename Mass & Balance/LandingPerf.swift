//
//  LandingPerf.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 16/11/2020.
//

import SwiftUI

struct LandingPerf: View {
    @ObservedObject var airports = LoadAirport()
    @ObservedObject var performance: Calculations
    @ObservedObject var settings = Settings()
    
    @State var selAirport = SelectedAirport()
    @State var selRunway = SelectedRunway()
    
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
                                selRunway = SelectedRunway()
                                performance.elevArr = String(selAirport.elevation ?? 0)
                                performance.slopeArr = ""
                                performance.lda = ""
                            }) {
                                Text("\(airport.icao) - \(airport.name)")
                            }
                        }
                        Button(action: {
                            selAirport = SelectedAirport()
                            selRunway = SelectedRunway()
                            performance.elevArr = ""
                            performance.slopeArr = ""
                            performance.lda = ""
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
                if selAirport.icao != nil {
                    HStack {
                        Text("Runway")
                        Spacer()
                        Menu {
                            ForEach(selAirport.runways!) { runway in
                                Button(action: {
                                    selRunway = SelectedRunway(name: runway.name, bearing: runway.bearing, slope: runway.slope, lda: runway.lda, intx: runway.intx)
                                    performance.lda = String(runway.lda)
                                    performance.slopeArr = String(runway.slope)
                                }) {
                                    Text(runway.name)
                                }
                            }
                        } label: {
                            if selRunway.name == "" {
                                Text("Select Runway")
                                    .frame(width: 150, alignment: .trailing)
                            } else {
                                Text("Runway \(selRunway.name ?? "")")
                                    .frame(width: 150, alignment: .trailing)
                            }
                        }.frame(width: 150, alignment: .trailing)
                    }
                }
            } // Airport Select
            Section() {
                HStack {
                    Text("Elevation")
                        .font(.callout)
                    TextField("Elevation", text: $performance.elevArr)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Air Pressure")
                        .font(.callout)
                    TextField("Pressure", text: $performance.qnhArr)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Pressure Altitude")
                        .font(.callout)
                    Spacer()
                    Text("\((performance.altArr), specifier: "%.0f")")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Temperature")
                        .font(.callout)
                    TextField("Temperature", text: $performance.tempArr)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Wind")
                        .font(.callout)
                    TextField("Wind Component", text: $performance.windArr)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                HStack {
                    Text("Down Slope")
                        .font(.callout)
                    TextField("Slope", text: $performance.slopeArr)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack(alignment: .leading) {
                    Text("Runway Condition")
                        .font(.callout)
                    Picker(selection: $performance.rwyCondArr, label: Text("Runway Condition")) {
                        Text("Paved Dry").tag(0)
                        Text("Paved Wet").tag(1)
                        Text("Grass Dry").tag(2)
                        Text("Grass Wet").tag(3)
                    }.pickerStyle(SegmentedPickerStyle())
                    .padding(.bottom)
                }
            }
            Section(header: Text("Landing mass: \(performance.lmMss, specifier: "%.0f") lbs, C.G: \(performance.lmArm, specifier: "%.1f") in.")) {
                HStack {
                    Text("Landing Distance Required")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        if performance.ldr < 984 {
                            Text("< 300 m")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\(((performance.ldr) * 0.305), specifier: "%.0f") m")
                                .foregroundColor(Color.gray)
                        }
                    } else {
                        if performance.ldr < 1000 {
                            Text("< 1000 ft")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\((performance.ldr), specifier: "%.0f") ft")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
                HStack {
                    Text("Landing Distance Required x 1.43")
                        .font(.callout)
                    Spacer()
                    if self.$settings.inMeters.wrappedValue == true {
                        if performance.ldr < 984 {
                            Text("< 300 m")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\((((performance.ldr) * 1.43) * 0.305), specifier: "%.0f") m")
                                .foregroundColor(Color.gray)
                        }
                    } else {
                        if performance.ldr < 1000 {
                            Text("< 1000 ft")
                                .foregroundColor(Color.gray)
                        } else {
                            Text("\(((performance.ldr) * 1.43), specifier: "%.0f") ft")
                                .foregroundColor(Color.gray)
                        }
                    }
                }
            }
            Section() {
                HStack {
                    Text("Landing Distance Available")
                        .font(.callout)
                    TextField("Distance", text: $performance.lda)
                        .keyboardType(.numbersAndPunctuation)
                        .multilineTextAlignment(.trailing)
                }
                VStack {
                    ZStack {
                        GeometryReader { geo in
                            Rectangle()
                                .fill(Color(UIColor.systemGray5))
                            if performance.lda == "" {
                                Text("Enter Landing Distance Available")
                                    .font(.callout)
                                    .foregroundColor(Color.gray)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            } else {
                                if self.$settings.inMeters.wrappedValue == true {
                                    if ((Double(performance.lda) ?? 0) - (performance.ldr * 1.43) * 0.305 ) < 95 {
                                        ZStack(alignment: .trailing) {
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray4))
                                                .frame(width: (geo.size.width) * CGFloat((performance.ldr * 1.43) * 0.305 / (Double(performance.lda) ?? 0)))
                                            Text("\(((Double(performance.lda) ?? 0) - ((performance.ldr * 1.43) * 0.305)), specifier: "%.0f") m remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal)
                                        }
                                    } else {
                                        HStack {
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray4))
                                                .frame(width: (geo.size.width) * CGFloat((performance.ldr * 1.43) * 0.305 / (Double(performance.lda) ?? 0)))
                                            Text("\(((Double(performance.lda) ?? 0) - ((performance.ldr * 1.43) * 0.305)), specifier: "%.0f") m remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                } else {
                                    if ((Double(performance.lda) ?? 0) - (performance.ldr * 1.43)) < 360 {
                                        ZStack(alignment: .trailing) {
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray4))
                                                .frame(width: (geo.size.width) * CGFloat((performance.ldr * 1.43) / (Double(performance.lda) ?? 0)))
                                            Text("\(((Double(performance.lda) ?? 0) - (performance.ldr * 1.43)), specifier: "%.0f") ft remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal)
                                        }
                                    } else {
                                        HStack {
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray4))
                                                .frame(width: (geo.size.width) * CGFloat((performance.ldr * 1.43) / (Double(performance.lda) ?? 0)))
                                            Text("\(((Double(performance.lda) ?? 0) - (performance.ldr * 1.43)), specifier: "%.0f") ft remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                        }
                                    }
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
        .navigationBarTitle("Landing Performance")
    }
}
