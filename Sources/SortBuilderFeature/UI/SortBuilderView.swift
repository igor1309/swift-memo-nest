//
//  SortBuilderView.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import SwiftUI

struct SortBuilderView<T>: View {
    
    @StateObject private var viewModel: SortBuilderModel<T>
    
    init(model: SortBuilderModel<T>) {
        
        self._viewModel = .init(wrappedValue: model)
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Picker(
                    "Select Key Path",
                    selection: .init(
                        get: { viewModel.state.selectedKeyPath },
                        set: { newValue in
                            viewModel.event(.updateSelectedKeyPath(newValue))
                        }
                    )
                ) {
                    Text("Select a key path").tag(Optional<String>.none)
                    ForEach(Array(viewModel.state.keyPaths.keys), id: \.self) { key in
                        Text(key).tag(Optional(key))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker(
                    "Order",
                    selection: .init(
                        get: { viewModel.state.sortOrder },
                        set: { newValue in
                            viewModel.event(.updateSortOrder(newValue))
                        }
                    )
                ) {
                    Text("Ascending").tag(SortOrder.forward)
                    Text("Descending").tag(SortOrder.reverse)
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical)
            
#warning("replace alert API with one from UIPrimitives")
            Button("Add Comparator") { viewModel.event(.addComparator) }
                .padding(.bottom)
                .disabled(viewModel.state.selectedKeyPath == nil)
                .alert(
                    isPresented: .init(
                        get: { viewModel.state.showingAlert },
                        set: { _ in viewModel.event(.updateSelectedKeyPath(nil)) }
                    )
                ) {
                    .init(
                        title: Text("Duplicate Comparator"),
                        message: Text("A comparator with the selected key path already exists."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            
            List {
                
                ForEach(viewModel.state.selectedComparators, id: \.keyPath) { comparator in
                    
                    if let key = viewModel.state.keyPaths.first(where: { $0.value == comparator.keyPath })?.key {
                        
                        Text("\(key) - \(comparator.order == .forward ? "Ascending" : "Descending")")
                    }
                }
                .onDelete { viewModel.event(.deleteComparators($0)) }
            }
            .listStyle(.plain)
            
            Button("Done") {
                
                let sort = Sort(comparators: viewModel.state.selectedComparators)
#warning("Do something with the sort object")
                print(sort)
            }
        }
        .padding()
    }
}

#if DEBUG
struct SortBuilderView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let keyPaths: [String: PartialKeyPath<Item>] = [
            "Name": \Item.name,
            "Age": \Item.age
        ]
        let reducer = SortBuilderReducer<Item>()
        
        SortBuilderView(
            model: SortBuilderModel<Item>(
                keyPaths: keyPaths,
                reduce: reducer.reduce
            )
        )
    }
}

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}
#endif
