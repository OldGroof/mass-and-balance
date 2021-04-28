//
//  LPSOMassBalanceApp.swift
//  LPSOMassBalance
//
//  Created by Jacob Webb on 04/11/2020.
//

import SwiftUI
import CoreData

@main
struct LPSOMassBalanceApp: App {
    
    let context = PersistentCloudKitContainer.persistentContainer.viewContext
    
    var body: some Scene {
        WindowGroup {
            Home().environment(\.managedObjectContext, context)
                .environmentObject(NavigationManager())
            //StackOverflow6().environmentObject(NavigationManager())
        }
    }
}

public class PersistentCloudKitContainer {

        public static var context: NSManagedObjectContext {
                return persistentContainer.viewContext
        }

        private init() {}

        public static var persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: "MassAndBalance")
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                        if let error = error as NSError? {
                                fatalError("Unresolved error \(error), \(error.userInfo)")
                        }
                })

                return container
        }()

        public static func saveContext () {
                let context = persistentContainer.viewContext
                if context.hasChanges {
                        do {
                                try context.save()
                        } catch {
                                let nserror = error as NSError
                                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                        }
                }
        }
}

class Settings: ObservableObject {
    
    @Published var inMeters: Bool = UserDefaults.standard.bool(forKey: "inMeters") {
        didSet {
            UserDefaults.standard.set(self.inMeters, forKey: "inMeters")
        }
    }
}

struct Model: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case reg
        case mass
        case arm
        case moment
        case type
    }
    var id = UUID()
    var reg, type: String
    var mass, moment: Int
    var arm: Float
}

class Json: ObservableObject {
    @Published var json = [Model]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "aircraftData", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([Model].self, from: data)
                    
                    DispatchQueue.main.sync {
                        self.json = json
                    }
                } else {
                    print("No data")
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}

struct NNMChecklist: Codable, Identifiable {
    enum CodingKeys: CodingKey {
        case section
        case checklists
    }
    var id = UUID()
    var section: String
    var checklists: [Checklist]
    
    struct Checklist: Codable, Identifiable {
        enum CodingKeys: CodingKey {
            case title
            case actions
        }
        var id = UUID()
        var title: String
        var actions: [Actions]
        
        struct Actions: Codable, Identifiable {
            enum CodingKeys: CodingKey {
                case name
                case action
            }
            var id = UUID()
            var name: String
            var action: String
        }
    }
}

class Checklist: Codable, Identifiable, ObservableObject {
    enum CodingKeys: CodingKey {
        case checklist
        case actions
    }
    var id = UUID()
    var checklist: String
    var actions: [Action]
    
    class Action: Codable, Identifiable, ObservableObject {
        enum CodingKeys: CodingKey {
            case name
            case action
        }
        var id = UUID()
        var name: String
        var action: String
        @Published var completed: Bool = false
    }
}

class QRH: ObservableObject {
    @Published var json = [NNMChecklist]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "PiperQRH", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([NNMChecklist].self, from: data)
                    
                    DispatchQueue.main.sync {
                        self.json = json
                    }
                } else {
                    print("No data")
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}

class CHKL: ObservableObject {
    @Published var json = [Checklist]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "PiperChecklist", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([Checklist].self, from: data)
                    
                    DispatchQueue.main.sync {
                        self.json = json
                    }
                } else {
                    print("No data")
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}

class Airport: Codable, Identifiable, ObservableObject {
    enum CodingKeys: CodingKey {
        case icao
        case name
        case elevation
        case runways
    }
    var id = UUID()
    var icao: String
    var name: String
    var elevation: Int
    var runways: [Runway]
}
class Runway: Codable, Identifiable, ObservableObject {
    enum CodingKeys: CodingKey {
        case name
        case bearing
        case slope
        case tora
        case toda
        case asda
        case lda
        case intx
    }
    var id = UUID()
    var name: String
    var bearing: Int
    var slope: Float
    var tora: Int
    var toda: Int
    var asda: Int
    var lda: Int
    
    var intx: [intersect]?
}
class intersect: Codable, Identifiable, ObservableObject {
    enum CodingKeys: CodingKey {
        case name
        case adjust
    }
    var id = UUID()
    var name: String
    var adjust: Int
}

class LoadAirport: ObservableObject {
    @Published var json = [Airport]()
    
    init() {
        load()
    }
    
    func load() {
        let path = Bundle.main.path(forResource: "airportData", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                if let data = data {
                    let json = try JSONDecoder().decode([Airport].self, from: data)
                    
                    DispatchQueue.main.sync {
                        self.json = json
                    }
                } else {
                    print("No data")
                }

            } catch {
                print(error)
            }
        }.resume()
    }
}

class Calculations: ObservableObject {

    var item: Model
    
    //MB inputs
    @Published var frntMss:String = ""
    @Published var rearMss:String = ""
    @Published var bggeMss:String = ""
    @Published var fuelTot:String = ""
    
    //Fuel Inputs
    @Published var fuelBrn:String = ""
    @Published var addtFl:String = ""
    @Published var altFuelBrn:String = ""
    
    //Fuel Calcs
    var contFuel:Double {
        return 0.1 * (Double(fuelBrn) ?? 0)
    }
    var fuelRqr: Int {
        let t2 = Double(fuelBrn) ?? 0
        let c = contFuel
        let a1 = Double(altFuelBrn) ?? 0
        let a2 = Double(addtFl) ?? 0
        return Int(8.0 + t2 + c + a1 + 43.0 + a2)
    }
    var tripTime: Int {
        Int((((Double(fuelBrn) ?? 0) / 6) / 9.5) * 60)
    }
    var contTime: Int {
        Int(((contFuel / 6) / 9.5) * 60)
    }
    var altTime: Int {
        Int((((Double(altFuelBrn) ?? 0) / 6) / 9.5) * 60)
    }
    var addtTime: Int {
        Int((((Double(addtFl) ?? 0) / 6) / 9.5) * 60)
    }
    var totTime: Int {
        Int(((Double(fuelRqr) / 6) / 9.5) * 60)
    }
    
    //MB variables
    var frntMom : Double { 80.5 * (Double(frntMss) ?? 0) }
    var rearMom : Double { 118.1 * (Double(rearMss) ?? 0) }
    var bggeMom : Double { 142.8 * (Double(bggeMss) ?? 0) }
    
    var zfmMom : Double { Double(item.moment) + frntMom + rearMom + bggeMom }
    var zfmMss : Double {
        let frnt = (Double(frntMss) ?? 0)
        let rear = (Double(rearMss) ?? 0)
        let bgge = (Double(bggeMss) ?? 0)
        return Double(item.mass) + frnt + rear + bgge
    }
    var zfmArm : Double { zfmMom / zfmMss }
    
    var fuelMom : Double { 95.0 * (Double(fuelTot) ?? 0) }
    
    var tomMom : Double { Double(zfmMom) + Double(fuelMom) - 760 }
    var tomMss : Double { Double(zfmMss ) + (Double(fuelTot) ?? 0) - 8 }
    var tomArm : Double { tomMom / tomMss }
    
    var burnMom : Double { 95.0 * -(Double(fuelBrn) ?? 0) }
    
    var lmMom : Double { Double(tomMom) + Double(burnMom) }
    var lmMss : Double { Double(tomMss) - (Double(fuelBrn) ?? 0) }
    var lmArm : Double { lmMom / lmMss }
    
    @Published var flaps = false
    @Published var tempDep:String = ""
    @Published var elevDep:String = ""
    @Published var qnhDep:String = ""
    @Published var windDep:String = ""
    @Published var slopeDep:String = ""
    @Published var rwyCondDep = 0
    
    @Published var toda:String = ""
    @Published var tora:String = ""
    @Published var asda:String = ""
    
    var altDep: Double {
        let pressCalc = (1013 - (Double(qnhDep) ?? 1013)) * 30
        return (Double(elevDep) ?? 0) + pressCalc
    }
    
    var altVar : Double {
        if altDep < 0 {
            return 0.2 * 0
        } else {
            return 0.2 * altDep
        }
    }
    var tempVar : Double { 21.5 * (Double(tempDep) ?? 0) }
    var windVar : Double { 18.5 * (Double(windDep) ?? 0) }
    var tomVar : Double {
        let x = tomMss
        let a = 0.00168824
        let b = -6.04939
        let c = 6447.05
        
        let y = ((a * (x * x)) + (b * (x)) + c)
        
        return 2000 - (y)
    }
    var slpVar : Double { (Double(slopeDep) ?? 0) / 2 }
    
    var altVarFlp:Double {
        if altDep < 0 {
            return 0.13 * 0
        } else {
            return 0.13 * altDep
        }
        }
    var tempVarFlp:Double { 16.9 * (Double(tempDep) ?? 0) }
    var windVarFlp:Double { 21 * (Double(windDep) ?? 0) }
    var tomVarFlp:Double { 1.53 * Double(2550-tomMss) }
    var slpVarFlp:Double { (Double(slopeDep) ?? 0) / 2 }
    
    
    // Ground Roll
    var grrlTemp:Double { 11 * (Double(tempDep) ?? 0) }
    var grrlAlt:Double {
        if altDep < 0 {
            return 0
        } else {
            return 0.105 * altDep
        }
    }
    var grrlMass:Double { 0.945 * Double(2550-tomMss)}
    var grrlWind:Double { 1.28 * (Double(windDep) ?? 0) }
    
    var grrlTempFlap: Double { 12 * (Double(tempDep) ?? 0) }
    var grrlAltFlap: Double {
        if altDep < 0 {
            return 0
        } else {
            return 0.1125 * altDep
        }
    }
    var grrlMassFlap:Double {
        let x = tomMss
        let a = 0.00000210063
        let b = -0.0134587
        let c = 29.6473
        let d = -21513.5
        
        let y = (a * (x * x * x)) + (b * (x * x)) + (c * x) + d
        
        return 1400 - y
    }
    var grrlWindFlap:Double { 14 * (Double(windDep) ?? 0) }
        
    var groundRoll: Double {
        if flaps == true {
            let result = 975 + grrlTempFlap + grrlAltFlap - grrlMassFlap - grrlWindFlap
            if result < 600 {
                return 600
            } else {
                return result
            }
        } else {
            let result = 925 + grrlTemp + grrlAlt - grrlMass - grrlWind
            if result < 400 {
                return 400
            } else {
                return result
            }
        }
    }
    
    var tod : Double {
        if flaps == true {
            return 1400 + altVarFlp + tempVarFlp - tomVarFlp - windVarFlp
        } else {
            let result = (1700 + altVar + tempVar - tomVar - windVar)
            if result < 1000 {
                return 1000
            } else {
                return result
            }
        }
        
    }
    var todr : Double {
        if rwyCondDep == 1 {
            return (tod + ((0.1 * tod) * slpVar)) * 1.2
        } else if rwyCondDep == 2 {
            return (tod + ((0.1 * tod) * slpVar)) * 1.3
        } else {
            return (tod + ((0.1 * tod) * slpVar))
        }
    }
    
    @Published var tempArr:String = ""
    @Published var elevArr:String = ""
    @Published var qnhArr:String = ""
    @Published var windArr:String = ""
    @Published var slopeArr:String = ""
    @Published var rwyCondArr = 0
    
    @Published var lda:String = ""
    
    var altArr: Double {
        let pressCalc = (1013 - (Double(qnhArr) ?? 1013)) * 30
        return (Double(elevArr) ?? 0) + pressCalc
    }
    
    var altVarArr : Double {
        if altArr < 0 {
            return 0.024 * 0
        } else {
            return 0.024 * altArr
        }
    }
    var tempVarArr : Double { 3.2 * (Double(tempArr) ?? 0) }
    var windVarArr : Double { 17.78 * (Double(windArr) ?? 0) }
    var tomVarArr : Double { 0.29 * Double(2550-(lmMss)) }
    var slpVarArr : Double { (Double(slopeArr) ?? 0) / 2 }

    var ld : Double {
        let result = 1360 + altVarArr + tempVarArr - tomVarArr - windVarArr
        if result < 1200 {
            return 1200
        } else {
            return result
        }
    }
    var ldr : Double {
        if rwyCondArr == 1 {
            return (ld + ((0.1 * ld) * slpVarArr)) * 1.15
        } else if rwyCondArr == 2 {
            return (ld + ((0.1 * ld) * slpVarArr)) * 1.15
        } else if rwyCondArr == 3 {
            return (ld + ((0.1 * ld) * slpVarArr)) * 1.35
        } else {
            return (ld + ((0.1 * ld) * slpVarArr))
        }
    }
    
    @Published var tempAlt:String = ""
    @Published var elevAlt:String = ""
    @Published var qnhAlt:String = ""
    @Published var windAlt:String = ""
    @Published var slopeAlt:String = ""
    @Published var rwyCondAlt = 0
    @Published var altICAO:String = ""
    
    var altMss : Double { tomMss - (Double(altFuelBrn) ?? 0) }
    var altArm : Double {
        let fuelMom = -(Double(altFuelBrn) ?? 0) * 95
        let altMom = tomMom + fuelMom
        return altMom / altMss
    }
    
    var altAlt: Double {
        let pressCalc = (1013 - (Double(qnhAlt) ?? 1013)) * 30
        return (Double(elevAlt) ?? 0) + pressCalc
    }
    
    @Published var ldaAlt:String = ""

    var altVarArrAlt : Double {
        if altAlt < 0 {
            return 0.024 * 0
        } else {
            return 0.024 * altAlt
        }
        }
    var tempVarArrAlt : Double { 3.2 * (Double(tempAlt) ?? 0) }
    var windVarArrAlt : Double { 17.78 * (Double(windAlt) ?? 0) }
    var tomVarArrAlt : Double { 0.29 * Double(2550-(altMss)) }
    var slpVarArrAlt : Double { (Double(slopeAlt) ?? 0) / 2 }

    var ldAlt : Double {
        let result = 1360 + altVarArrAlt + tempVarArrAlt - tomVarArrAlt - windVarArrAlt
        if result < 1200 {
            return 1200
        } else {
            return result
        }
    }
    var ldrAlt : Double {
        if rwyCondAlt == 1 {
            return (ldAlt + ((0.1 * ldAlt) * slpVarArrAlt)) * 1.15
        } else if rwyCondAlt == 2 {
            return (ldAlt + ((0.1 * ldAlt) * slpVarArrAlt)) * 1.15
        } else if rwyCondAlt == 3 {
            return (ldAlt + ((0.1 * ldAlt) * slpVarArrAlt)) * 1.35
        } else {
            return (ldAlt + ((0.1 * ldAlt) * slpVarArrAlt))
        }
    }
    
    init(item: Model) {
        self.item = item
    }
}

struct Metar : Decodable {
    let data:[String]?
}
struct Taf : Decodable {
    let data:[String]?
}

struct LPPTTaf:Decodable {
    let raw:String?
}
