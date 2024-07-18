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
    case updateSelectedKeyPath(String?)
    case updateSortOrder(SortOrder)
}

final class SortBuilderReducer<T> {
    
    func reduce(
        state: inout SortBuilderState<T>,
        event: SortBuilderEvent
    ) {
        switch event {
        case .addComparator:
            addComparator(state: &state)
            
        case let .deleteComparators(offsets):
            state.selectedComparators.remove(atOffsets: offsets)
            
        case let .updateSelectedKeyPath(newValue):
            state.selectedKeyPath = newValue
            
        case let .updateSortOrder(newValue):
            state.sortOrder = newValue
        }
    }
    
    private func addComparator(state: inout SortBuilderState<T>) {
        
        if let key = state.selectedKeyPath, let keyPath = state.keyPaths[key] {
            if state.selectedComparators.contains(where: { $0.keyPath == keyPath }) {
                state.showingAlert = true
            } else {
                if let keyPath = keyPath as? KeyPath<T, String> {
                    state.selectedComparators.append(.init(keyPath, order: state.sortOrder))
                } else if let keyPath = keyPath as? KeyPath<T, Int> {
                    state.selectedComparators.append(.init(keyPath, order: state.sortOrder))
                }
                // Add more types as needed
            }
        }
    }
}

final class SortBuilderModel<T>: ObservableObject {
    
    @Published private(set) var state: SortBuilderState<T>
    
    private let reduce: (inout SortBuilderState<T>, SortBuilderEvent) -> Void
    
    init(
        keyPaths: [String: PartialKeyPath<T>],
        reduce: @escaping (inout SortBuilderState<T>, SortBuilderEvent) -> Void
    ) {
        self.reduce = reduce
        self.state = .init(selectedKeyPath: keyPaths.keys.first, keyPaths: keyPaths)
    }
    
    func event(_ event: SortBuilderEvent) {
        
        reduce(&state, event)
    }
}

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
                reduce: reducer.reduce
            )
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
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
#endif
