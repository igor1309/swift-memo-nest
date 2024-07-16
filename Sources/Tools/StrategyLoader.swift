//
//  StrategyLoader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

public final class StrategyLoader<Payload, Success, Failure: Error> {
    
    private let primary: any Primary
    private let secondary: any Secondary
    
    init(
        primary: any Primary,
        secondary: any Secondary
    ) {
        self.primary = primary
        self.secondary = secondary
    }
    
    public typealias Primary = Loader<Payload, Success, Error>
    public typealias Secondary = Loader<Payload, Success, Failure>
}

extension StrategyLoader: Loader {
    
    public func load(
        _ payload: Payload,
        _ completion : @escaping (Result<Success, Failure>) -> Void
    ) {
        primary.load(payload) { [weak self] in
        
            guard let self else { return }
            
            switch $0 {
            case .failure:
                secondary.load(payload, completion)
                
            case let .success(success):
                completion(.success(success))
            }
        }
    }
}
