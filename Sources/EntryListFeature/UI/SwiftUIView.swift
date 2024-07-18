//
//  SwiftUIView.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

#if canImport(SwiftUI)
import SwiftUI

// The Sort struct
struct Sort<T> {
    let comparators: [KeyPathComparator<T>]
}

// Example data model
struct Item: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}

// View to construct Sort object
struct SortBuilderView<T>: View {
    @State private var selectedComparators: [KeyPathComparator<T>] = []
    @State private var selectedKeyPath: String? = nil
    @State private var sortOrder: SortOrder = .forward
    @State private var showingAlert = false
    
    let keyPaths: [String: PartialKeyPath<T>]
    
    var body: some View {
        VStack {
            HStack {
                Picker("Select Key Path", selection: $selectedKeyPath) {
                    Text("Select a key path").tag(String?.none)
                    ForEach(Array(keyPaths.keys), id: \.self) { key in
                        Text(key).tag(String?.some(key))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Picker("Order", selection: $sortOrder) {
                    Text("Ascending").tag(SortOrder.forward)
                    Text("Descending").tag(SortOrder.reverse)
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical)
            
            Button("Add Comparator") {
                if let key = selectedKeyPath, let keyPath = keyPaths[key] {
                    if selectedComparators.contains(where: { $0.keyPath == keyPath }) {
                        showingAlert = true
                    } else {
                        if let keyPath = keyPath as? KeyPath<T, String> {
                            selectedComparators.append(KeyPathComparator(keyPath, order: sortOrder))
                        } else if let keyPath = keyPath as? KeyPath<T, Int> {
                            selectedComparators.append(KeyPathComparator(keyPath, order: sortOrder))
                        }
                        // Add more types as needed
                    }
                }
            }
            .padding(.bottom)
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Duplicate Comparator"),
                    message: Text("A comparator with the selected key path already exists."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            List {
                ForEach(selectedComparators, id: \.keyPath) { comparator in
                    if let key = keyPaths.first(where: { $0.value == comparator.keyPath })?.key {
                        Text("\(key) - \(comparator.order == .forward ? "Ascending" : "Descending")")
                    }
                }
                .onDelete { indices in
                    selectedComparators.remove(atOffsets: indices)
                }
            }
            .listStyle(PlainListStyle())
            
            Button("Done") {
                let sort = Sort(comparators: selectedComparators)
                // Do something with the sort object
                print(sort)
            }
        }
        .padding()
        .onAppear {
            if selectedKeyPath == nil, let firstKey = keyPaths.keys.first {
                selectedKeyPath = firstKey
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        SortBuilderView<Item>(
            keyPaths: [
                "Name": \Item.name,
                "Age": \Item.age
            ]
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
