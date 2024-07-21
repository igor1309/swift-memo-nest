//
//  EditorFlowModel.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import Foundation
import EntryEditorFeature
import IMRx

typealias EditorFlowModel = RxViewModel<EditorFlowState<EntryEditorFeature.Entry>, EditorFlowEvent<EntryEditorFeature.Entry>, EditorFlowEffect<EntryEditorFeature.Entry>>
