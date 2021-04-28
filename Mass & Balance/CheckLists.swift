//
//  CheckLists.swift
//  LPSOLPSOMassBalance
//
//  Created by Jacob Webb on 10/01/2021.
//

import SwiftUI

struct NormChecklists: View {
    @State private var showModal = false
    @State var selectedCHKL: Checklist? = nil
    @ObservedObject var checklists = CHKL()
    
    var body: some View {
        List() {
            ForEach(checklists.json) { checklist in
                Button(action: {
                    self.showModal = true
                    self.selectedCHKL = checklist
                }) {
                    Text(checklist.checklist)
                        .foregroundColor(.gray)
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .sheet(item: $selectedCHKL) { check in
            ChecklistView(checkList: check)
        }
        .navigationBarTitle("Piper Normal Checklists")
    }
}

struct ChecklistView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var checkList: Checklist
    
    var body: some View {
        VStack {
            HStack {
                Text(checkList.checklist)
                    .font(.title)
                Spacer()
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            List(checkList.actions, id: \.id) { item in
                ActionView(action: item)
            }
        }.padding()
    }
}

struct ActionView: View {
    @ObservedObject var action: Checklist.Action

    init(action: Checklist.Action) {
        self.action = action
    }

    var body: some View {
        if action.action == "" {
            Text(action.name).italic()
                .multilineTextAlignment(.center)
                .font(.callout)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
        } else {
            Button(action: {
                action.completed.toggle()
            }) {
                if action.completed {
                    HStack {
                        Image(systemName: "checkmark.square")
                            .foregroundColor(.green)
                        Text(action.name)
                            .foregroundColor(.green)
                        Spacer()
                        Text(action.action)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } else {
                    HStack {
                        Image(systemName: "square")
                        Text(action.name)
                        Spacer()
                        Text(action.action)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}


struct NonNormChecklists: View {
    @State private var showModal = false
    @State var selectedCHKL: NNMChecklist.Checklist? = nil
    @ObservedObject var checklists = QRH()
    
    var body: some View {
        List() {
            ForEach(checklists.json) { item in
                Section() {
                    Text(item.section)
                    ForEach(item.checklists) { chkl in
                        Button(action: {
                            self.showModal = true
                            self.selectedCHKL = chkl
                        }) {
                            Text(chkl.title)
                        }
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Piper QRH")
        .sheet(item: $selectedCHKL) { check in
            ModalView(checkList: check)
        }
    }
}

struct ModalView: View {
    @Environment(\.presentationMode) var presentationMode
    var checkList: NNMChecklist.Checklist

    var body: some View {
        VStack {
            HStack {
                Text(checkList.title)
                    .font(.title)
                Spacer()
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
            List() {
                ForEach(checkList.actions) { item in
                    if item.action == "" {
                        Text(item.name).italic()
                            .multilineTextAlignment(.center)
                            .font(.callout)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    } else {
                        HStack{
                            Text(item.name)
                            Spacer()
                            Text(item.action)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }.padding()
    }
}
