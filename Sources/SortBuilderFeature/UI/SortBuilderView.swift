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
            
            comparatorView()
                .padding(.vertical)
            
            addComparatorButton()
                .padding(.bottom)

            comparatorList()
            
            Button("Done") {
                
#warning("Do something with the sort object")
                print(viewModel.state.sort)
            }
        }
        .padding()
    }
}

private extension SortBuilderState {
    
    var sort: Sort<T> {
     
        return .init(comparators: selectedComparators)
    }
}

private extension SortBuilderView {
    
    func comparatorView() -> some View {
        
        HStack {
            
            keyPathPicker()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            sortOrderPicker()
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .pickerStyle(.menu)
    }
    
    func keyPathPicker() -> some View {
        
        Picker(
            "Select Key Path",
            selection: .init(
                get: { viewModel.state.selectedKeyPath },
                set: { viewModel.event(.updateSelectedKeyPath($0)) }
            )
        ) {
            Text("Select a key path").tag(Optional<String>.none)
            
            ForEach(Array(viewModel.state.keyPaths.keys), id: \.self) { key in
                
                Text(key).tag(Optional(key))
            }
        }
    }
    
    func sortOrderPicker() -> some View {
        
        Picker(
            "Order",
            selection: .init(
                get: { viewModel.state.sortOrder },
                set: { viewModel.event(.updateSortOrder($0)) }
            )
        ) {
            Text("Ascending").tag(SortOrder.forward)
            Text("Descending").tag(SortOrder.reverse)
        }
    }
    
#warning("replace alert API with one from UIPrimitives")
    func addComparatorButton() -> some View {
        
        Button("Add Comparator") { viewModel.event(.addComparator) }
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
    }
    
    func comparatorList() -> some View {
        
        List {
            
            ForEach(viewModel.state.selectedComparators, id: \.keyPath) { comparator in
                
                if let key = viewModel.state.keyPaths.first(where: { $0.value == comparator.keyPath })?.key {
                    
                    Text("\(key) - \(comparator.order == .forward ? "Ascending" : "Descending")")
                }
            }
            .onDelete { viewModel.event(.deleteComparators($0)) }
        }
        .listStyle(.plain)
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
