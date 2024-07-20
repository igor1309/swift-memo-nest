//
//  ListFlowState.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature

#warning("explore a way to conform to Equatable")
struct ListFlowState {
 
    #warning("explore a way to decouple from concrete content type")
    let content: Content
    var destination: Destination? = nil
    var modal: Modal? = nil
}

extension ListFlowState {
    
    typealias Content = EntryListModel<Entry>
    
    enum Destination: Equatable {
        
        case detail(Detail)
        
        struct Detail: Equatable {
            
            let entry: Entry
            var modal: Modal? = nil
            
            enum Modal: Equatable {
                
                case editor(Entry)
            }
        }
    }
    
    enum Modal: Equatable {
        
        case editor
    }
}
