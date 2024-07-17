//
//  EntryListReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

public final class EntryListReducer<Entry: Identifiable> {
    
    public init() {}
}

public extension EntryListReducer {
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .load:
            state.status = .inflight
            effect = .load
            
        case let .loaded(result):
            reduce(&state, with: result)
            
        case let .loadMore(after: id):
            state.status = .inflight
            effect = .loadMore(after: id)
            
        case let .save(entry):
            reduce(&state, with: entry)
        }
        
        return (state, effect)
    }
}

public extension EntryListReducer {
    
    typealias State = EntryListState<Entry>
    typealias Event = EntryListEvent<Entry>
    typealias Effect = EntryListEffect<Entry>
}

private extension EntryListReducer {
    
    func reduce(
        _ state: inout State,
        with result: Event.LoadResult
    ) {
        state.status = nil
        
        switch result {
        case let .failure(failure):
            switch state.result {
            case .none:
                state.result = .failure(failure)
                
            case .failure, .success:
                // ???
                break
            }
            
        case let .success(entries):
            switch state.result {
            case .none, .failure:
                state.result = .success(entries)
                
            case var .success(existingEntries):
                existingEntries += entries
                state.result = .success(existingEntries)
            }
        }
    }
    
    func reduce(
        _ state: inout State,
        with entry: Entry
    ) {
        var entries = (try? state.result?.get()) ?? []
        
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
        } else {
            entries.append(entry)
        }
        
        state.result = .success(entries)
    }
}
