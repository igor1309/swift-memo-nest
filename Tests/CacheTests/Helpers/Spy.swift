//
//  Spy.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

final class Spy<Payload, Success, Failure: Error> {
    
    typealias Completion = (Result<Success, Failure>) -> Void
    typealias Message = (payload: Payload, completion: Completion)
    
    private(set) var messages = [Message]()
    
    var callCount: Int { messages.count }
    var payloads: [Payload] { messages.map(\.payload) }
    
    func process(
        _ payload: Payload,
        completion: @escaping Completion
    ) {
        messages.append((payload, completion))
    }
    
    func complete(
        with result: Result<Success, Failure>,
        at index: Int = 0
    ) {
        messages[index].completion(result)
    }
}

extension Spy where Payload == Void {
    
    func process(completion: @escaping Completion) {
        
        process((), completion: completion)
    }
}
