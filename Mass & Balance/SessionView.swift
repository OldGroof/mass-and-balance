//
//  SessionView.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 18/11/2020.
//

import SwiftUI
import SafariServices

struct SessionView: View {
    @State private var showModal = false
    @Environment(\.openURL) var openURL
    var entity: Saves
    @State var save:Saves? = nil
    @ObservedObject var settings = Settings()
    
    @State var EGTCm:String = "METAR here plz"
    @State var EGTCt:String = "No TAF for you!"
    @State var EGSCm:String = "METAR here plz"
    @State var EGSCt:String = "No TAF for you!"
    @State var EGTKm:String = "METAR here plz"
    @State var EGTKt:String = "No TAF for you!"
    @State var EGBJm:String = "METAR here plz"
    @State var EGBJt:String = "No TAF for you!"
    
    var body: some View {
        Form {
            Section() {
                HStack{
                    Image(systemName: "cloud")
                    Text("Weather")
                    Spacer()
                    Button(action: {
                        metar()
                        EGTCtaf()
                        EGSCtaf()
                        EGTKtaf()
                        EGBJtaf()
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                HStack {
                    VStack {
                        HStack {
                            Text("Cranfield")
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: 130)
                    VStack(alignment: .leading) {
                        Text(EGTCm)
                            .foregroundColor(.gray)
                        Text("TAF \(EGTCt)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } // Cranfield
                HStack {
                    VStack{
                        HStack {
                            Text("Cambridge")
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: 130)
                    VStack(alignment: .leading) {
                        Text(EGSCm)
                            .foregroundColor(.gray)
                        Text("TAF \(EGSCt)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } // Cambridge
                HStack {
                    VStack{
                        HStack {
                            Text("Oxford")
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: 130)
                    VStack(alignment: .leading) {
                        Text(EGTKm)
                            .foregroundColor(.gray)
                        Text("TAF \(EGTKt)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } // Oxford
                HStack {
                    VStack {
                        HStack {
                            Text("Gloucestershire")
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: 130)
                    VStack(alignment: .leading) {
                        Text(EGBJm)
                            .foregroundColor(.gray)
                        Text("TAF \(EGBJt)")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                } // Gloucestershire
                Button(action: {
                    openURL(URL(string: "http://www.metoffice.gov.uk/premium/generalaviation/#/aerodromes")!)
                }) {
                    HStack {
                        Image(systemName: "link.icloud")
                        Text("UK Met Office")
                    }
                }
            } // Weather
            Section() {
                HStack {
                    Image(systemName: "cube.box")
                    Text("Masses")
                }
                Button(action: {
                    self.showModal = true
                    self.save = entity
                }) {
                    VStack {
                        VStack {
                            HStack {
                                Text("Zero Fuel Mass")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(entity.zfm)) lbs")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Text("Center of Gravity")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(entity.zfa, specifier: "%.1f") in")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        VStack {
                            HStack {
                                Text("Take off Mass")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(entity.tom)) lbs")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Text("Center of Gravity")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(entity.toa, specifier: "%.1f") in")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        VStack {
                            HStack {
                                Text("Landing Mass")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(String(entity.lm)) lbs")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Text("Center of Gravity")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(entity.la, specifier: "%.1f") in")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                        if entity.altMss == entity.tom {
                            Text("No alternate airport data")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            VStack {
                                HStack {
                                    Text("Alternate Mass")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(String(entity.altMss)) lbs")
                                        .font(.callout)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Spacer()
                                        .frame(width: 15)
                                    Text("Center of Gravity")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(entity.altArm, specifier: "%.1f") in")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                        }
                    }
                }
                NavigationLink(destination: GraphSession(zMss: Double(entity.zfm), zArm: Double(entity.zfa), tMss: Double(entity.tom), tArm: Double(entity.toa), lMss: Double(entity.lm), lArm: Double(entity.la))) {
                    Text("C.G. Range and Weight Graph")
                }
            } // Masses
            Section() {
                HStack {
                    Image(systemName: "drop")
                    Text("Fuel Plan")
                }
                GeometryReader { geometry in
                    ZStack {
                        VStack {
                            ForEach(0..<8) { row in
                                HStack {
                                    ForEach(0..<3) { column in
                                        Rectangle()
                                            .stroke(Color.gray, lineWidth: 1)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                            .padding(-4)
                                    }
                                }
                            }
                        }
                        VStack {
                            HStack {
                                Text("")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                VStack {
                                    Text("Fuel")
                                        .font(.title2)
                                    Text("lbs")
                                        .font(.subheadline)
                                }.frame(width: geometry.size.width / 3, height: 50)
                                VStack {
                                    Text("Time")
                                        .font(.title2)
                                    Text("minutes")
                                        .font(.subheadline)
                                }.frame(width: geometry.size.width / 3, height: 50)
                            }.padding(-4)
                            HStack {
                                VStack {
                                    Text("Taxi")
                                        .font(.title2)
                                    Text("Start, taxi and run up")
                                }.frame(width: geometry.size.width / 3, height: 50)
                                Text("8")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("10")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                Text("Trip")
                                    .font(.title2)
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.burn)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.tripTime)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                VStack {
                                    Text("Contingency")
                                        .font(.title2)
                                    Text("10% of trip")
                                        .font(.subheadline)
                                }.frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.contFuel, specifier: "%.1f")")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.contTime)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                VStack {
                                    Text("Alternate")
                                        .font(.title2)
                                    Text(entity.altICAO ?? "")
                                        .font(.subheadline)
                                }.frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.altFuelBrn)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.altTime)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                VStack {
                                    Text("Final Reserve")
                                        .font(.title2)
                                    Text("45 mins")
                                        .font(.subheadline)
                                }.frame(width: geometry.size.width / 3, height: 50)
                                Text("43")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("45")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                Text("Additional")
                                    .font(.title2)
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.addtFl)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.addtTime)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                            HStack {
                                Text("Total Required")
                                    .font(.title2)
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.fuelRqr)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                Text("\(entity.totTime)")
                                    .frame(width: geometry.size.width / 3, height: 50)
                                
                            }.padding(-4)
                        }
                    }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                }.frame(height: 410)
            } // Fuel Plan
            Section() {
                HStack {
                    Image(systemName: "a.circle")
                    Text("Departure Aerodrome Data")
                }
                VStack {
                    if entity.flaps == true {
                        HStack {
                            Spacer()
                            Text("Flaps 25°")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text("Flaps Up")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        Text("Elevation")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Double(entity.elevDep), specifier: "%.0f") ft")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Air Pressure")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.qnhDep)) hPa")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Pressure Altitude")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\((Double(entity.elevDep) + ((1013 - Double(entity.qnhDep)) * 30)), specifier: "%.0f") ft")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Temperature")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.tempDep)) °C")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Wind")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.windDep)) kts")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Up Slope")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.slopeDep)) °")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Runway Condition")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        if entity.rwyCondDep == 0 {
                            Text("Paved")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else if entity.rwyCondDep == 1 {
                            Text("Grass Dry")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            Text("Grass Wet")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        if entity.meters == true {
                            Text("Take off Distance: \(entity.todr) m")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("Take off Distance: \(entity.todr) ft")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }.padding(.top)
                }
                if entity.tora == 0 {
                    if entity.meters == true {
                        HStack {
                            Text("Take off Distance Required:")
                            Spacer()
                            Text("\((Double(entity.todr) * 1.25),specifier: "%.0f") m")
                        }
                    } else {
                        HStack{
                            Text("Take off Distance Required:")
                            Spacer()
                            Text("\((Double(entity.todr) * 1.25),specifier: "%.0f") ft")
                        }
                    }
                } else {
                    VStack {
                        HStack {
                            Text("Take off Run Available")
                            Spacer()
                            if entity.meters == true {
                                Text("\(Double(entity.tora), specifier: "%.0f") m")
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(Double(entity.tora), specifier: "%.0f") ft")
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack {
                            Text("Take off Distance Available")
                            Spacer()
                            if entity.meters == true {
                                Text("\(Double(entity.toda), specifier: "%.0f") m")
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(Double(entity.toda), specifier: "%.0f") ft")
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack {
                            Text("Accelerate Stop Distance Available")
                            Spacer()
                            if entity.meters == true {
                                Text("\(Double(entity.asda), specifier: "%.0f") m")
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(Double(entity.asda), specifier: "%.0f") ft")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    VStack {
                        ZStack {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(UIColor.systemGray5))
                                if entity.tora != entity.toda {
                                    VStack(alignment: .leading) {
                                        Rectangle()
                                            .fill(Color(UIColor.systemTeal))
                                            .frame(width: (geo.size.width) * CGFloat(Double(entity.todr) / Double(entity.tora)), height: 10)
                                        Rectangle()
                                            .fill(Color(UIColor.systemBlue))
                                            .frame(width: (geo.size.width) * CGFloat((Double(entity.todr) * 1.15) / Double(entity.toda)), height: 10)
                                            .padding(.vertical, -8)
                                        Rectangle()
                                            .fill(Color(UIColor.systemIndigo))
                                            .frame(width: (geo.size.width) * CGFloat((Double(entity.todr) * 1.3) / Double(entity.asda)), height: 10)
                                            .padding(.vertical, -6)
                                    }
                                } else {
                                    Rectangle()
                                        .fill(Color(UIColor.systemBlue))
                                        .frame(width: (geo.size.width) * CGFloat((Double(entity.todr) * 1.25) / Double(entity.asda)))
                                }
                            }
                        }.clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(height: 30)
                        if entity.tora != entity.toda {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemTeal))
                                    .frame(width: 8, height: 8)
                                if entity.meters == true {
                                    Text("Take off Distance Required: \(Double(entity.todr),specifier: "%.0f") m")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("Take off Distance Required: \(Double(entity.todr),specifier: "%.0f") ft")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemBlue))
                                    .frame(width: 8, height: 8)
                                if entity.meters == true {
                                    Text("TODR x 1.15: \((Double(entity.todr) * 1.15),specifier: "%.0f") m")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("TODR x 1.15: \((Double(entity.todr) * 1.15),specifier: "%.0f") ft")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemIndigo))
                                    .frame(width: 8, height: 8)
                                if entity.meters == true {
                                    Text("TODR x 1.30: \((Double(entity.todr) * 1.3),specifier: "%.0f") m")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("TODR x 1.30: \((Double(entity.todr) * 1.3),specifier: "%.0f") ft")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }
                        } else {
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemBlue))
                                    .frame(width: 8, height: 8)
                                if entity.meters == true {
                                    Text("TODR x 1.25: \((Double(entity.todr) * 1.25),specifier: "%.0f") m")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("TODR x 1.25: \((Double(entity.todr) * 1.25),specifier: "%.0f") ft")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            } // Take off Details
            Section() {
                HStack {
                    Image(systemName: "b.circle")
                    Text("Arrival Aerodrome Data")
                }
                VStack {
                    HStack {
                        Text("Elevation")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Double(entity.elevArr), specifier: "%.0f") ft")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Air Pressure")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.qnhArr)) hPa")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Pressure Altitude")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\((Double(entity.elevArr) + ((1013 - Double(entity.qnhArr)) * 30)), specifier: "%.0f") ft")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Temperature")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.tempArr)) °C")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Wind")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.windArr)) kts")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Down Slope")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(String(entity.slopeArr)) °")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Runway Condition")
                            .font(.callout)
                            .foregroundColor(.gray)
                        Spacer()
                        if entity.rwyCondArr == 0 {
                            Text("Paved Dry")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else if entity.rwyCondArr == 1 {
                            Text("Paved Wet")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else if entity.rwyCondArr == 2 {
                            Text("Grass Dry")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            Text("Grass Wet")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                    }
                    HStack {
                        if entity.meters == true {
                            Text("Landing Distance: \(entity.ldr) m")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("Landing Distance: \(entity.ldr) ft")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }.padding(.top)
                }
                if entity.lda == 0 {
                    if entity.meters == true {
                        HStack {
                            Text("Landing Distance Required:")
                            Spacer()
                            Text("\((Double(entity.ldr) * 1.43),specifier: "%.0f") m")
                        }
                    } else {
                        HStack{
                            Text("Landing Distance Required:")
                            Spacer()
                            Text("\((Double(entity.ldr) * 1.43),specifier: "%.0f") ft")
                        }
                    }
                } else {
                    HStack {
                        Text("Landing Distance Available")
                        Spacer()
                        if entity.meters == true {
                            Text("\(Double(entity.lda), specifier: "%.0f") m")
                                .foregroundColor(.gray)
                        } else {
                            Text("\(Double(entity.lda), specifier: "%.0f") ft")
                                .foregroundColor(.gray)
                        }
                    }
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color(UIColor.systemGray5))
                            GeometryReader { geo in
                                ZStack(alignment: .trailing) {
                                    Rectangle()
                                        .fill(Color(UIColor.systemGray4))
                                        .frame(width: (geo.size.width) * CGFloat((Double(entity.ldr) * 1.43) / Double(entity.lda)))
                                    if entity.meters == true {
                                        Text("\((Double(entity.lda) - (Double(entity.ldr) * 1.43)), specifier: "%.0f") m remaining")
                                            .font(.subheadline)
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                    } else {
                                        Text("\((Double(entity.lda) - (Double(entity.ldr) * 1.43)), specifier: "%.0f") ft remaining")
                                            .font(.subheadline)
                                            .foregroundColor(Color.white)
                                            .padding(.horizontal)
                                    }
                                }
                            }
                        }.clipShape(RoundedRectangle(cornerRadius: 5))
                        .frame(height: 30)
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.systemGray4))
                                .frame(width: 8, height: 8)
                            if entity.meters == true {
                                Text("LDR x 1.43: \(Double(entity.ldr) * 1.43, specifier: "%.0f") m")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            } else {
                                Text("LDR x 1.43: \(Double(entity.ldr) * 1.43, specifier: "%.0f") ft")
                                    .font(.subheadline)
                                    .foregroundColor(Color.gray)
                            }
                            Spacer()
                        }
                    }
                }
            } // Landing Details
            if entity.altICAO != "" {
                Section() {
                    HStack{
                        Image(systemName: "c.circle")
                        Text("Alternate Aerodrome Data")
                        Spacer()
                        Text(entity.altICAO ?? "")
                    }
                    VStack {
                        if entity.flapsAlt == true {
                            HStack {
                                Spacer()
                                Text("Flaps 25°")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("Flaps Up")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack {
                            Text("Elevation")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(Double(entity.elevAlt), specifier: "%.0f") ft")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Air Pressure")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(entity.qnhAlt)) hPa")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Pressure Altitude")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\((Double(entity.elevAlt) + ((1013 - Double(entity.qnhAlt)) * 30)), specifier: "%.0f") ft")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Temperature")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(entity.tempAlt)) °C")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Wind")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(entity.windAlt)) kts")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Up Slope")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(String(entity.slopeAlt)) °")
                                .font(.callout)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Runway Condition")
                                .font(.callout)
                                .foregroundColor(.gray)
                            Spacer()
                            if entity.rwyCondAlt == 0 {
                                Text("Paved Dry")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            } else if entity.rwyCondAlt == 1 {
                                Text("Paved Wet")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            } else if entity.rwyCondAlt == 2 {
                                Text("Grass Dry")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Grass Wet")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                        }
                        HStack {
                            if entity.meters == true {
                                Text("Landing Distance: \(entity.ldrAlt) m")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            } else {
                                Text("Landing Distance: \(entity.ldrAlt) ft")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }.padding(.top)
                    }
                    if entity.ldaAlt == 0 {
                        if entity.meters == true {
                            HStack {
                                Text("Landing Distance Required:")
                                Spacer()
                                Text("\((Double(entity.ldrAlt) * 1.43),specifier: "%.0f") m")
                            }
                        } else {
                            HStack{
                                Text("Landing Distance Required:")
                                Spacer()
                                Text("\((Double(entity.ldrAlt) * 1.43),specifier: "%.0f") ft")
                            }
                        }
                    } else {
                        HStack {
                            Text("Landing Distance Available")
                            Spacer()
                            if entity.meters == true {
                                Text("\(Double(entity.ldaAlt), specifier: "%.0f") m")
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(Double(entity.ldaAlt), specifier: "%.0f") ft")
                                    .foregroundColor(.gray)
                            }
                        }
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color(UIColor.systemGray5))
                                GeometryReader { geo in
                                    ZStack(alignment: .trailing) {
                                        Rectangle()
                                            .fill(Color(UIColor.systemGray4))
                                            .frame(width: (geo.size.width) * CGFloat((Double(entity.ldrAlt) * 1.43) / Double(entity.ldaAlt)))
                                        if entity.meters == true {
                                            Text("\((Double(entity.ldaAlt) - (Double(entity.ldrAlt) * 1.43)), specifier: "%.0f") m remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal)
                                        } else {
                                            Text("\((Double(entity.ldaAlt) - (Double(entity.ldrAlt) * 1.43)), specifier: "%.0f") ft remaining")
                                                .font(.subheadline)
                                                .foregroundColor(Color.white)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                            }.clipShape(RoundedRectangle(cornerRadius: 5))
                            .frame(height: 30)
                            HStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(UIColor.systemGray4))
                                    .frame(width: 8, height: 8)
                                if entity.meters == true {
                                    Text("LDR x 1.43: \(Double(entity.ldrAlt) * 1.43, specifier: "%.0f") m")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                } else {
                                    Text("LDR x 1.43: \(Double(entity.ldrAlt) * 1.43, specifier: "%.0f") ft")
                                        .font(.subheadline)
                                        .foregroundColor(Color.gray)
                                }
                                Spacer()
                            }
                        }
                    }
                }
            } // Alternate Details
            Section() {
                HStack {
                    Image(systemName: "list.bullet.indent")
                    Text("Useful Links")
                }
                HStack{
                    Spacer()
                    VStack{
                        Image(systemName: "list.bullet.indent")
                            .foregroundColor(.blue)
                            .padding(2)
                            .font(.system(size: 50))
                        Text("NATS")
                    }.frame(width: 125)
                    .onTapGesture {
                        openURL(URL(string: "http://www.nats-uk.ead-it.com/fwf-natsuk/public/user/account/login.faces")!)
                    }
                    Spacer()
                    VStack{
                        Image(systemName: "map")
                            .foregroundColor(.blue)
                            .padding(2)
                            .font(.system(size: 50))
                        Text("NATS eAIP")
                    }.frame(width: 125)
                    .onTapGesture {
                        openURL(URL(string: "https://www.aurora.nats.co.uk/htmlAIP/Publications/2021-04-22-AIRAC/html/index-en-GB.html")!)
                    }
                    Spacer()
                }.padding(4)
            } // Useful Links
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitle("\(entity.callsign ?? "") Briefing")
        .sheet(item: $save) { save in
            MassTable(entity: save)
        }
        .onAppear() {
            metar()
            EGTCtaf()
            EGTKtaf()
            EGSCtaf()
            EGBJtaf()
        }
    }
    
    func metar() {
        
        let url = URL(string: "https://api.checkwx.com/metar/EGTC,EGSC,EGBJ,EGTK")!
        var request = URLRequest(url: url)
        request.addValue("6f5de2372b0543bc9959c51695", forHTTPHeaderField: "X-API-Key")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }
            // check for 200 OK status
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Metar.self, from: data)
                let wxrSorted = weather.data?.sorted()
                
                EGBJm = String(wxrSorted?[0] ?? "")
                EGSCm = String(wxrSorted?[1] ?? "")
                EGTCm = String(wxrSorted?[2] ?? "")
                EGTKm = String(wxrSorted?[3] ?? "")
                
            } catch let err {
                print ("Json Err", err)
            }
        }.resume()
        
    }
    func EGTCtaf() {
        let url = URL(string: "https://avwx.rest/api/taf/EGTC")!
        var request = URLRequest(url: url)
        request.addValue("vTzmtdwxOfCF21hIR6YeeL9WF-JVSKTZHBBgv5boIBc", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }
            // check for 200 OK status
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(LPPTTaf.self, from: data)
                
                EGTCt = weather.raw ?? ""
            } catch let err {
                print ("Json Err", err)
            }
        }.resume()
        
    }
    func EGSCtaf() {
        let url = URL(string: "https://avwx.rest/api/taf/EGSC")!
        var request = URLRequest(url: url)
        request.addValue("vTzmtdwxOfCF21hIR6YeeL9WF-JVSKTZHBBgv5boIBc", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }
            // check for 200 OK status
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(LPPTTaf.self, from: data)
                
                EGSCt = weather.raw ?? ""
            } catch let err {
                print ("Json Err", err)
            }
        }.resume()
        
    }
    func EGTKtaf() {
        let url = URL(string: "https://avwx.rest/api/taf/EGTK")!
        var request = URLRequest(url: url)
        request.addValue("vTzmtdwxOfCF21hIR6YeeL9WF-JVSKTZHBBgv5boIBc", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }
            // check for 200 OK status
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(LPPTTaf.self, from: data)
                
                EGTKt = weather.raw ?? ""
            } catch let err {
                print ("Json Err", err)
            }
        }.resume()
        
    }
    func EGBJtaf() {
        let url = URL(string: "https://avwx.rest/api/taf/EGBJ")!
        var request = URLRequest(url: url)
        request.addValue("vTzmtdwxOfCF21hIR6YeeL9WF-JVSKTZHBBgv5boIBc", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // check for error
            if error != nil {
                print(error!.localizedDescription)
            }
            // check for 200 OK status
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(LPPTTaf.self, from: data)
                
                EGBJt = weather.raw ?? ""
            } catch let err {
                print ("Json Err", err)
            }
        }.resume()
        
    }
}

struct MassTable: View {
    var entity: Saves
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Mass and Balance Table")
                        .font(.title)
                    Spacer()
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ZStack {
                    VStack {
                        ForEach(0..<11) { row in
                            HStack {
                                ForEach(0..<4) { column in
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 1)
                                        .frame(width: geometry.size.width / 4, height: 50)
                                        .padding(-4)
                                }
                            }
                        }
                    } // Table Base
                    VStack {
                        HStack {
                            Text("")
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                            VStack {
                                Text("Lever Arm")
                                Text("inches")
                                    .font(.caption)
                            }.frame(width: geometry.size.width / 4, height: 50)
                            .padding(-4)
                            VStack {
                                Text("Mass")
                                Text("lbs")
                                    .font(.caption)
                            }.frame(width: geometry.size.width / 4, height: 50)
                            .padding(-4)
                            VStack {
                                Text("Moment")
                                Text("in-lbs")
                                    .font(.caption)
                            }.frame(width: geometry.size.width / 4, height: 50)
                            .padding(-4)
                        } // Header
                        VStack {
                            HStack {
                               Text("Empty Mass")
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("\(entity.bemArm, specifier: "%.2f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.bemMss)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.bemMom)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // BEM
                            HStack {
                               Text("Front Seats")
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("80.5")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.frnt)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((80.5 * Double(entity.frnt)), specifier: "%.0f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // Front Seats
                            HStack {
                               Text("Rear Seats")
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("118.1")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.rear)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((118.1 * Double(entity.rear)), specifier: "%.0f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // Rear Seats
                            HStack {
                                VStack {
                                    Text("Baggage Comp.")
                                    Text("Max 200lbs")
                                        .font(.caption)
                                }.frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("142.8")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.bgge)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((142.8 * Double(entity.bgge)), specifier: "%.0f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // Baggage
                            HStack {
                               Text("Zero Fuel Mass")
                                .fontWeight(.semibold)
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("\(entity.zfa, specifier: "%.1f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.zfm)")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((entity.zfa * Double(entity.zfm)), specifier: "%.0f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // ZFM
                            HStack {
                                VStack {
                                    Text("Fuel")
                                    Text("Max 288lbs")
                                        .font(.caption)
                                }.frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("95.0")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.fuel)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((95.0 * Double(entity.fuel)), specifier: "%.0f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // Fuel
                            HStack {
                                VStack {
                                    Text("Fuel Allowance")
                                    Text("Start up, taxi & run up")
                                        .font(.caption)
                                }.frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("95")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("-8")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("-760")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // SUTRO Fuel
                            HStack {
                               Text("Take off Mass")
                                .fontWeight(.semibold)
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("\(entity.toa, specifier: "%.1f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.tom)")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((entity.toa * Double(entity.tom)), specifier: "%.0f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // TOM
                            HStack {
                               Text("Fuel Burn")
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("95.0")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.burn)")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((-95.0 * Double(entity.burn)), specifier: "%.0f")")
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // Fuel Burn
                            HStack {
                               Text("Landing Mass")
                                .fontWeight(.semibold)
                                .frame(width: geometry.size.width / 4, height: 50)
                                .padding(-4)
                                Text("\(entity.la, specifier: "%.1f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\(entity.lm)")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                                Text("\((entity.la * Double(entity.lm)), specifier: "%.0f")")
                                    .fontWeight(.semibold)
                                 .frame(width: geometry.size.width / 4, height: 50)
                                    .padding(-4)
                            } // LM
                        }
                    }

                }
                Spacer()
            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }.padding()
    }
}
