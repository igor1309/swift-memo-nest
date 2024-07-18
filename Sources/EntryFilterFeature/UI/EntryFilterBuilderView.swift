//
//  EntryFilterBuilderView.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import SwiftUI

struct EntryFilterBuilderView: View {
    
    @ObservedObject var model: EntryFilterBuilderModel

    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .leading, spacing: 32) {
                
                combinationPicker()
                searchTextField()
                tagsTextField()
                dateRangePicker()
            }
            .padding()
        }
        
        Text("Current Filter: \(model.state.filter)")
            .font(.footnote)
            .padding(.horizontal)
    }
}

private extension EntryFilterBuilderView {
    
    func combinationPicker() -> some View {
        
        HStack {
            
            Text("Combine as")
                .padding(.trailing)
            
            Picker("Combination", selection: .init(
                get: { model.state.combination },
                set: { model.event(.setCombination($0)) }
            )) {
                Text("AND").tag(FilterCombination.and)
                Text("OR").tag(FilterCombination.or)
            }
            .pickerStyle(.segmented)
        }
    }
    
    func searchTextField() -> some View {
        
        TextField("Search Text", text: .init(
            get: { model.state.searchText },
            set: { model.event(.setSearchText($0)) }
        ))
        .textFieldStyle(.roundedBorder)
    }
    
    func tagsTextField() -> some View {
        
        TextField("Tags (comma separated)", text: .init(
            get: { model.state.tags },
            set: { model.event(.setTags($0)) }
        ))
        .textFieldStyle(.roundedBorder)
    }
    
    @ViewBuilder
    func dateRangePicker() -> some View {
        
        DatePicker("Start Date", selection: .init(
            get: { model.state.startDate },
            set: { model.event(.setStartDate($0)) }
        ), displayedComponents: .date)

        DatePicker("End Date", selection: .init(
            get: { model.state.endDate },
            set: { model.event(.setEndDate($0)) }
        ), displayedComponents: .date)
    }
}

#if DEBUG
struct EntryFilterBuilderView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let reducer = EntryFilterBuilderReducer()
        let model = EntryFilterBuilderModel(
            reduce: reducer.reduce(state:event:)
        )
        
        NavigationStack {
            
            EntryFilterBuilderView(model: model)
                .navigationTitle("Filter Entries")
        }
    }
}
#endif
