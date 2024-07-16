//
//  ListFlowModel.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

final class ListFlowModel: ObservableObject {
    
    @Published private(set) var route: Route
    
    init(route: Route = .init()) {
     
        self.route = route
    }
}

extension ListFlowModel {
    
    struct Route: Equatable {
        
        var destination: Destination? = nil
        var modal: Modal? = nil
    }
}

extension ListFlowModel.Route {
    
    enum Destination: Equatable {
        
        case detail
    }
    
    enum Modal: Equatable {
        
        case editor
    }
}
