//
//  EntryListModel.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation
import IMRx

public typealias EntryListModel<Entry: Identifiable> = RxViewModel<EntryListState<Entry>, EntryListEvent<Entry>, EntryListEffect<Entry>>
