//
//  SwiftUIView.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

#if canImport(SwiftUI)
import Foundation

struct SortBuilderState<T> {
    var selectedComparators: [KeyPathComparator<T>] = []
    var selectedKeyPath: String? = nil
    var sortOrder: SortOrder = .forward
    var showingAlert = false
    let keyPaths: [String: PartialKeyPath<T>]
}

enum SortBuilderEvent {
    case addComparator
    case deleteComparators(IndexSet)
}

final class SortBuilderReducer<T> {
    func reduce(state: inout SortBuilderState<T>, event: SortBuilderEvent) {
        switch event {
        case .addComparator:
            addComparator(state: &state)
        case .deleteComparators(let offsets):
            state.selectedComparators.remove(atOffsets: offsets)
        }
    }
    
    private func addComparator(state: inout SortBuilderState<T>) {
        if let key = state.selectedKeyPath, let keyPath = state.keyPaths[key] {
            if state.selectedComparators.contains(where: { $0.keyPath == keyPath }) {
                state.showingAlert = true
            } else {
                if let keyPath = keyPath as? KeyPath<T, String> {
                    state.selectedComparators.append(KeyPathComparator(keyPath, order: state.sortOrder))
                } else if let keyPath = keyPath as? KeyPath<T, Int> {
                    state.selectedComparators.append(KeyPathComparator(keyPath, order: state.sortOrder))
                }
                // Add more types as needed
            }
        }
    }
}

final class SortBuilderModel<T>: ObservableObject {
    
    @Published private(set) var state: SortBuilderState<T>
    
    private let reducer: (inout SortBuilderState<T>, SortBuilderEvent) -> Void
    
    init(keyPaths: [String: PartialKeyPath<T>], reducer: @escaping (inout SortBuilderState<T>, SortBuilderEvent) -> Void) {
        self.reducer = reducer
        self.state = SortBuilderState(selectedKeyPath: keyPaths.keys.first, keyPaths: keyPaths)
    }
    
    func handleEvent(_ event: SortBuilderEvent) {
        reducer(&state, event)
    }
}

import SwiftUI

struct SortBuilderView<T>: View {
    @StateObject private var viewModel: SortBuilderModel<T>
    
    init(model: SortBuilderModel<T>) {
        _viewModel = StateObject(wrappedValue: model)
    }
    
    var body: some View {
        VStack {
            HStack {
                Picker("Select Key Path", selection: $viewModel.state.selectedKeyPath) {
                    Text("Select a key path").tag(String?.none)
                    ForEach(Array(viewModel.state.keyPaths.keys), id: \.self) { key in
                        Text(key).tag(String?.some(key))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Order", selection: $viewModel.state.sortOrder) {
                    Text("Ascending").tag(SortOrder.forward)
                    Text("Descending").tag(SortOrder.reverse)
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical)
            
            Button("Add Comparator") {
                viewModel.handleEvent(.addComparator)
            }
            .padding(.bottom)
            .alert(isPresented: $viewModel.state.showingAlert) {
                Alert(
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
                .onDelete { indices in
                    viewModel.handleEvent(.deleteComparators(indices))
                }
            }
            .listStyle(.plain)
            
            Button("Done") {
                let sort = Sort(comparators: viewModel.state.selectedComparators)
                // Do something with the sort object
                print(sort)
            }
        }
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        let keyPaths: [String: PartialKeyPath<Item>] = [
            "Name": \Item.name,
            "Age": \Item.age
        ]
        let reducer = SortBuilderReducer<Item>()
        
        SortBuilderView(
            model: SortBuilderModel<Item>(
                keyPaths: keyPaths,
                reducer: reducer.reduce
            )
        )
    }
}

struct Sort<T> {
    let comparators: [KeyPathComparator<T>]
}

// Example data model
struct Item: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
