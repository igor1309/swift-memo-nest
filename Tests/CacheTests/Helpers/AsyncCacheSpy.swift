//
//  AsyncCacheSpy.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

#warning("remake - see CallSpy")
actor AsyncCacheSpy<Entry> {
    
    private var stub: [Result<[Entry], Error>]
    private(set) var messages = [Message]()
    var callCount: Int { messages.count }
    
    init(stub: [Result<[Entry], Error>]) {
        
        self.stub = stub
    }
    
    func cache(_ entry: Entry) async {
        
        messages.append(.cache(entry))
    }
    
    func remove(_ entry: Entry) async throws {
        
        messages.append(.remove(entry))
    }
    
    func retrieveAll() async throws -> [Entry] {
        
        try stub.removeFirst().get()
    }
    
    enum Message {
        
        case cache(Entry)
        case remove(Entry)
    }
}

extension AsyncCacheSpy.Message: Equatable where Entry: Equatable {}
