//
//  MassTable.swift
//  LPSOperformanceance
//
//  Created by Jacob Webb on 05/11/2020.
//

import SwiftUI

struct MassBal: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saves.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saves.reg, ascending: false)]
    ) var entities: FetchedResults<Saves>
    
    var item: Model
    
    @State var callsign:String = ""
    @State private var showingAlert = false
    
    @ObservedObject var performance: Calculations
    @ObservedObject var settings = Settings()

    init(item: Model) {
        self.item = item
        self.performance = Calculations(item: item)
    }

    var body: some View {
                List {
                    Section() {
                        HStack {
                            Image(systemName: "cube.box")
                            Text("Mass and Balance")
                        }
                        GeometryReader { geometry in
                                VStack {
                                    ZStack {
                                        HStack {
                                            Spacer()
                                                .frame(width: geometry.size.width / 4)
                                            VStack {
                                                Text("Lever Arm")
                                                    .font(.title2)
                                                Text("in")
                                                    .font(.subheadline)
                                            }.frame(width: geometry.size.width / 4, height: 45)
                                            VStack {
                                                Text("Mass")
                                                    .font(.title2)
                                                Text("lbs")
                                                    .font(.subheadline)
                                            }.frame(width: geometry.size.width / 4, height: 45)
                                            VStack {
                                                Text("Moment")
                                                    .font(.title2)
                                                Text("in-lbs")
                                                    .font(.subheadline)
                                            }.frame(width: geometry.size.width / 4, height: 45)
                                        } // Text
                                        HStack {
                                            ForEach(0..<4) { cell in
                                                Rectangle()
                                                    .stroke(Color.gray, lineWidth: 1)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }
                                        } // Cells
                                    }.padding(.bottom, -4) // Header
                                    ZStack {
                                        VStack {
                                            ForEach(0..<10) { row in
                                                HStack {
                                                    ForEach(0..<4) { cell in
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
                                                Text("Empty Mass")
                                                    .font(.title)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("\(item.arm, specifier: "%.2f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("\(item.mass)")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("\(item.moment)")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                Text("Front Seats")
                                                    .font(.title)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("80.5")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                TextField("-", text: $performance.frntMss)
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("\(performance.frntMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                Text("Rear Seats")
                                                    .font(.title)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("118.1")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                TextField("-", text: $performance.rearMss)
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("\(performance.rearMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                VStack {
                                                    Text("Baggage")
                                                        .font(.title)
                                                    Text("Max 200lbs")
                                                        .font(.subheadline)
                                                }.frame(width: geometry.size.width / 4, height: 50)
                                                .padding(.horizontal, -4)
                                                Text("142.8")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                TextField("-", text: $performance.bggeMss)
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: geometry.size.width / 4, height: 60)
                                                    .padding(.horizontal, -4)
                                                Text("\((performance.bggeMom), specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                Text("Zero Fuel Mass")
                                                    .font(.title2)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                if performance.zfmArm < 82.0 {
                                                    Text("\(performance.zfmArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else if performance.zfmArm > 93.0 {
                                                    Text("\(performance.zfmArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.zfmArm, specifier: "%.1f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                if performance.zfmMss > 2550 {
                                                    Text("\(performance.zfmMss, specifier: "%.0f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.zfmMss, specifier: "%.0f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                Text("\(performance.zfmMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                VStack {
                                                    Text("Fuel")
                                                        .font(.title)
                                                    Text("Max 48usg")
                                                        .font(.subheadline)
                                                }.frame(width: geometry.size.width / 4, height: 50)
                                                .padding(.horizontal, -4)
                                                Text("95.0")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                TextField("-", text: $performance.fuelTot)
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: geometry.size.width / 4, height: 60)
                                                    .padding(.horizontal, -4)
                                                Text("\(performance.fuelMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                VStack {
                                                    Text("Fuel Allowance")
                                                        .font(.title)
                                                    Text("Start, taxi and run up")
                                                        .font(.subheadline)
                                                }.frame(width: geometry.size.width / 4, height: 50)
                                                .padding(.horizontal, -4)
                                                Text("95.0")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("-8")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                Text("-760")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                Text("Take off Mass")
                                                    .font(.title2)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                if performance.tomArm < 82.0 {
                                                    Text("\(performance.tomArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else if performance.tomArm > 93.0 {
                                                    Text("\(performance.tomArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.tomArm, specifier: "%.1f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                if performance.tomMss > 2550 {
                                                    Text("\(performance.tomMss, specifier: "%.0f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.tomMss, specifier: "%.0f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                Text("\(performance.tomMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                            HStack {
                                                VStack {
                                                    Text("Fuel Burn")
                                                        .font(.title)
                                                    Text("Omit negative sign")
                                                        .font(.subheadline)
                                                }.frame(width: geometry.size.width / 4, height: 50)
                                                .padding(.horizontal, -4)
                                                Text("95.0")
                                                    .fontWeight(.bold)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                TextField("-", text: $performance.fuelBrn)
                                                    .keyboardType(.decimalPad)
                                                    .multilineTextAlignment(.center)
                                                    .frame(width: geometry.size.width / 4, height: 60)
                                                    .padding(.horizontal, -4)
                                                Text("\(performance.burnMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                        }.padding(-6)
                                            HStack {
                                                Text("Landing Mass")
                                                    .font(.title2)
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                                if performance.lmArm < 82.0 {
                                                    Text("\(performance.lmArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else if performance.lmArm > 93.0 {
                                                    Text("\(performance.lmArm, specifier: "%.1f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.lmArm, specifier: "%.1f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                if performance.lmMss > 2550 {
                                                    Text("\(performance.lmMss, specifier: "%.0f")")
                                                        .fontWeight(.bold)
                                                        .foregroundColor(Color.red)
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                } else {
                                                    Text("\(performance.lmMss, specifier: "%.0f")")
                                                        .frame(width: geometry.size.width / 4, height: 50)
                                                        .padding(.horizontal, -4)
                                                }
                                                Text("\(performance.lmMom, specifier: "%.0f")")
                                                    .frame(width: geometry.size.width / 4, height: 50)
                                                    .padding(.horizontal, -4)
                                            }.padding(-6)
                                        } // Table Details
                                    }
                                }.position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Table
                        }.frame(height: 550)
                        NavigationLink(destination: Graph(performance: self.performance)) {
                                Text("C.G. Range and Weight Graph")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding(4)
                            }
                    }
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
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("10")
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                    HStack {
                                        Text("Trip")
                                            .font(.title2)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        TextField("-", text: $performance.fuelBrn)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("\(performance.tripTime)")
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                    HStack {
                                        VStack {
                                            Text("Contingency")
                                                .font(.title2)
                                            Text("10% of trip")
                                                .font(.subheadline)
                                        }.frame(width: geometry.size.width / 3, height: 50)
                                        Text("\(performance.contFuel, specifier: "%.1f")")
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("\(performance.contTime)")
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                    HStack {
                                        Text("Alternate")
                                            .font(.title2)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        TextField("-", text: $performance.altFuelBrn)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("\(performance.altTime)")
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
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("45")
                                            .fontWeight(.bold)
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                    HStack {
                                        Text("Additional")
                                            .font(.title2)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        TextField("-", text: $performance.addtFl)
                                            .keyboardType(.decimalPad)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        Text("\(performance.addtTime)")
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                    HStack {
                                        Text("Total Required")
                                            .font(.title2)
                                            .frame(width: geometry.size.width / 3, height: 50)
                                        if performance.fuelRqr > (Int(performance.fuelTot) ?? 288) {
                                            Text("Check Fuel")
                                                .fontWeight(.bold)
                                                .foregroundColor(.red)
                                                .frame(width: geometry.size.width / 3, height: 50)
                                        } else {
                                            Text("\(performance.fuelRqr)")
                                                .frame(width: geometry.size.width / 3, height: 50)
                                        }
                                        Text("\(performance.totTime)")
                                            .frame(width: geometry.size.width / 3, height: 50)

                                    }.padding(-4)
                                }
                            }.position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }.frame(height: 410)
                    }
                    Section() {
                        HStack {
                            Image(systemName: "a.circle")
                            Text("Take off Performance")
                        }
                        NavigationLink(destination: TakeOffPerf(performance: self.performance)) {
                            VStack {
                                HStack {
                                    Text("Take off Mass")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.tomMss, specifier: "%.0f") lbs")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Text("Center of Gravity")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.tomArm, specifier: "%.1f") in")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                            }.padding(4)
                        }
                    }
                    Section() {
                        HStack {
                            Image(systemName: "b.circle")
                            Text("Landing Performance")
                        }
                        NavigationLink(destination: LandingPerf(performance: self.performance)) {
                            VStack {
                                HStack {
                                    Text("Landing Mass")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.lmMss, specifier: "%.0f") lbs")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Text("Center of Gravity")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.lmArm, specifier: "%.1f") in")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                            }.padding(4)
                        }
                    }
                    Section() {
                        HStack {
                            Image(systemName: "c.circle")
                            Text("Alternate Performance")
                        }
                        NavigationLink(destination: AlternatePerf(performance: self.performance)) {
                            VStack {
                                HStack {
                                    Text("Mass at Alternate Airport")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.altMss, specifier: "%.0f") lbs")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                HStack {
                                    Text("Center of Gravity")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text("\(performance.altArm, specifier: "%.1f") in")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                            }.padding(4)
                        }
                    }
                }.listStyle(InsetGroupedListStyle())
                .padding(.top, -20)
                .navigationBarTitle(Text(item.reg), displayMode: .inline)
                .navigationBarItems(trailing:
                                        HStack {
                                            Spacer()
                                            Button(action: {
                                                self.$settings.inMeters.wrappedValue = true
                                            }) {
                                                if self.$settings.inMeters.wrappedValue == false {
                                                    Text("Meters")
                                                        .fontWeight(.medium)
                                                        .padding(.vertical, 13)
                                                        .frame(width: 55)
                                                } else {
                                                    Text("Meters")
                                                        .fontWeight(.light)
                                                        .padding(.vertical, 13)
                                                        .foregroundColor(.gray)
                                                        .frame(width: 55)
                                                }
                                            }
                                            Button(action: {
                                                self.$settings.inMeters.wrappedValue = false
                                            }) {
                                                if self.$settings.inMeters.wrappedValue == true {
                                                    Text("Feet")
                                                        .fontWeight(.medium)
                                                        .padding(.vertical, 13)
                                                        .frame(width: 55)
                                                } else {
                                                    Text("Feet")
                                                        .fontWeight(.light)
                                                        .padding(.vertical, 13)
                                                        .foregroundColor(.gray)
                                                        .frame(width: 55)
                                                }

                                            }
                                            Button(action: {
                                                saveFlight()
                                            }) {
                                                Text("Save")
                                            }
                                        }

        )
    }
    
    func saveFlight() {
        
        let alert = UIAlertController(title: "Saving Flight", message: "Enter a Flight Number (optional)", preferredStyle: .alert)
        
        alert.addTextField { (callsign) in
            callsign.placeholder = item.reg
            callsign.autocapitalizationType = .allCharacters
            callsign.textAlignment = .center
        }
        
        let save = UIAlertAction(title: "Save", style: .default) {_ in
            let newEntry = Saves(context: self.moc)
            newEntry.date = Date()
            if alert.textFields![0].text! == "" {
                newEntry.callsign = item.reg
            } else {
                newEntry.callsign = alert.textFields![0].text!
            }
            newEntry.reg = item.reg
            newEntry.type = item.type
            newEntry.bemArm = Double(item.arm)
            newEntry.bemMss = Int64(item.mass)
            newEntry.bemMom = Int64(item.moment)
            newEntry.frnt = Int64(performance.frntMss) ?? 0
            newEntry.rear = Int64(performance.rearMss) ?? 0
            newEntry.bgge = Int64(performance.bggeMss) ?? 0
            newEntry.fuel = Int64(performance.fuelTot) ?? 0
            newEntry.burn = Int64(performance.fuelBrn) ?? 0
            newEntry.zfm = Int64(performance.zfmMss)
            newEntry.zfa = performance.zfmArm
            newEntry.tom = Int64(performance.tomMss)
            newEntry.toa = performance.tomArm
            newEntry.lm = Int64(performance.lmMss)
            newEntry.la = performance.lmArm
            
            newEntry.addtFl = Int64(performance.addtFl) ?? 0
            newEntry.contFuel = performance.contFuel
            newEntry.tripTime = Int64(performance.tripTime)
            newEntry.contTime = Int64(performance.contTime)
            newEntry.altFuelBrn = Int64(performance.altFuelBrn) ?? 0
            newEntry.altTime = Int64(performance.altTime)
            newEntry.addtTime = Int64(performance.addtTime)
            newEntry.totTime = Int64(performance.totTime)
            newEntry.fuelRqr = Int64(performance.fuelRqr)
            
            newEntry.elevDep = Int64(performance.elevDep) ?? 0
            newEntry.qnhDep = Int64(performance.qnhDep) ?? 1013
            newEntry.tempDep = Int64(performance.tempDep) ?? 0
            newEntry.windDep = Int64(performance.windDep) ?? 0
            newEntry.slopeDep = Double(performance.slopeDep) ?? 0
            newEntry.rwyCondDep = Int64(performance.rwyCondDep)
            newEntry.flaps = performance.flaps
            if settings.inMeters == true {
                newEntry.todr = Int64(performance.todr * 0.305)
            } else {
                newEntry.todr = Int64(performance.todr)
            }
            newEntry.toda = Int64(performance.toda) ?? Int64(performance.tora) ?? 0
            newEntry.tora = Int64(performance.tora) ?? 0
            newEntry.asda = Int64(performance.asda) ?? Int64(performance.tora) ?? 0
            
            newEntry.elevArr = Int64(performance.elevArr) ?? 0
            newEntry.qnhArr = Int64(performance.qnhArr) ?? 1013
            newEntry.tempArr = Int64(performance.tempArr) ?? 0
            newEntry.windArr = Int64(performance.windArr) ?? 0
            newEntry.slopeArr = Double(performance.slopeArr) ?? 0
            newEntry.rwyCondArr = Int64(performance.rwyCondArr)
            if settings.inMeters == true {
                newEntry.ldr = Int64(performance.ldr * 0.305)
            } else {
                newEntry.ldr = Int64(performance.ldr)
            }
            newEntry.lda = Int64(performance.lda) ?? 0
            
            newEntry.altICAO = performance.altICAO
            newEntry.altMss = Int64(performance.altMss)
            newEntry.altArm = Double(performance.altArm)
            newEntry.elevAlt = Int64(performance.elevAlt) ?? 0
            newEntry.qnhAlt = Int64(performance.qnhAlt) ?? 1013
            newEntry.tempAlt = Int64(performance.tempAlt) ?? 0
            newEntry.windAlt = Int64(performance.windAlt) ?? 0
            newEntry.slopeAlt = Double(performance.slopeAlt) ?? 0
            newEntry.rwyCondAlt = Int64(performance.rwyCondAlt)
            
            if settings.inMeters == true {
                newEntry.ldrAlt = Int64(performance.ldrAlt * 0.305)
            } else {
                newEntry.ldrAlt = Int64(performance.ldrAlt)
            }
            newEntry.ldaAlt = Int64(performance.ldaAlt) ?? 0
            
            newEntry.meters = settings.inMeters
            
            if self.moc.hasChanges {
                try? self.moc.save()
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(save)
        alert.addAction(cancel)
        
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: { })
    }
}
