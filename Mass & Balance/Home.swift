//
//  Home.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 04/11/2020.
//

import SwiftUI
import SafariServices

class NavigationManager: ObservableObject{
    @Published private(set) var dest: AnyView? = nil
    @Published var isActive: Bool = false

    func move(to: AnyView) {
        self.dest = to
        self.isActive = true
    }
}

struct Home: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @ObservedObject var settings = Settings()
    @Environment(\.openURL) var openURL
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Saves.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Saves.reg, ascending: true)]) var flights: FetchedResults<Saves>
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    func removeSessions(at offsets: IndexSet) {
        for index in offsets {
            let entity = flights[index]
            moc.delete(entity)
        }
        do {
            try moc.save()
        } catch {
            // handle the Core Data error
        }
    }
    
    @State var EGTCm:String = "METAR here plz"
    @State var EGTCt:String = "No TAF for you!"
    @State var EGSCm:String = "METAR here plz"
    @State var EGSCt:String = "No TAF for you!"
    @State var EGTKm:String = "METAR here plz"
    @State var EGTKt:String = "No TAF for you!"
    @State var EGBJm:String = "METAR here plz"
    @State var EGBJt:String = "No TAF for you!"
   
    @State private var showModal = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                List() {
                    Section() {
                        HStack {
                            Image(systemName: "airplane")
                            Text("New Flight")
                        }
                        HStack {
                            HStack {
                                Text("Select Aircraft")
                                    .foregroundColor(Color(UIColor.label))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(UIColor.systemGray2))
                                    .font(Font.system(size: 13, weight: .semibold))
                            }.contentShape(Rectangle())
                            .onTapGesture{
                                self.showModal = true
                            }
                            NavigationLink(destination: self.navigationManager.dest, isActive: self.$navigationManager.isActive) {
                                EmptyView()
                            }.hidden()
                            .frame(width: 0)
                        }
                    } // Select Aircraft
                    Section() {
                        HStack {
                            Image(systemName: "paperplane")
                            Text("Saved Flights")
                        }
                        ForEach(flights, id: \.self) { entity in
                            NavigationLink(destination: SessionView(entity: entity)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                            Text(entity.callsign ?? "Unknown")
                                                .font(.title)
                                        HStack {
                                            Text(entity.type ?? "Unknown")
                                                .font(.subheadline)
                                            Text("-")
                                            Text(entity.reg ?? "N/A")
                                                .font(.subheadline)
                                        }
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        if entity.date != nil {
                                            Text("\(entity.date ?? Date(), formatter: Self.dateFormat)")
                                                .font(.subheadline)
                                                .foregroundColor(Color.gray)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }.onDelete(perform: removeSessions)
                    } // Saved Flights
                    Section() {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text("Checklists")
                        }
                        NavigationLink(destination: NonNormChecklists()) {
                            HStack{
                                Image(systemName: "exclamationmark.octagon.fill")
                                    .padding(2)
                                Text("Piper QRH")
                            }
                        }
                        NavigationLink(destination: NormChecklists()) {
                            HStack {
                                Image(systemName: "text.badge.checkmark")
                                    .padding(2)
                                Text("Piper Normal Checklist")
                            }
                        }
                    } // Checklists
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
                    } // NOTAMS
                }.listStyle(InsetGroupedListStyle())
                .navigationBarTitle(Text(""), displayMode: .inline)
                .navigationBarItems(leading:
                                        Image("Logo1").resizable()
                                        .frame(width: 45, height: 45)
                                        .position(x: (geometry.size.width / 2.0) + -22.5, y: 22.5)
                )
                .sheet(isPresented: $showModal) {
                    SelectAircraft().environmentObject(self.navigationManager)
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
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

struct SelectAircraft: View {
    @EnvironmentObject var navigationManager: NavigationManager
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var datas = Json()
    @State var dest: AnyView? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Select Aircraft")
                    .font(.title)
                Spacer()
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            List {
                ForEach(datas.json) { item in
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                        self.dest = AnyView(MassBal(item: item))
                    }) {
                        HStack {
                            VStack {
                                Text(item.reg)
                                    .font(.title)
                                Text(item.type)
                                    .font(.subheadline)
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("BEM: \(item.mass) lbs.")
                                    .font(.caption)
                                Text("Arm: \(item.arm, specifier: "%.2f") in.")
                                    .font(.caption)
                                Text("Moment: \(item.moment) in-lbs.")
                                    .font(.caption)
                            }
                        }
                    }
                }
            }
        }.padding()
        .onDisappear {
            // This code can run any where but I placed it in `.onDisappear` so you can see the animation
            if let dest = self.dest {
                self.navigationManager.move(to: dest)
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
