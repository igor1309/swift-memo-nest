//
//  CallSpy.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

final class CallSpy<Payload, Response> {
    
    private(set) var payloads = [Payload]()
    private var stubs: [Response]
    
    init(stubs: [Response] = []) {
        
        self.stubs = stubs
    }
}

extension CallSpy {
    
    var callCount: Int { payloads.count }
    
    func call(payload: Payload) -> Response {
        
        payloads.append(payload)
        return stubs.removeFirst()
    }
}

extension CallSpy where Payload == Void {
    
    func call() -> Response {
        
        self.call(payload: ())
    }
}

extension CallSpy {
    
    func call<A, B>(_ a: A, _ b: B) -> Response
    where Payload == (A, B) {
        
        self.call(payload: (a, b))
    }
}

extension CallSpy {
    
    func call<Success, Failure: Error>(
        payload: Payload
    ) throws -> Success where Response == Result<Success, Failure> {
        
        try self.call(payload: payload).get()
    }
}

extension CallSpy {
    
    func call<Success, Failure: Error>() throws -> Success
    where Payload == Void,
          Response == Result<Success, Failure> {
              
              try self.call(payload: ())
          }
}
