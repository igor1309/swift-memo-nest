// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-note-nest",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .noteNest,
        .uiPrimitives,
    ],
    targets: [
        .noteNest,
        .noteNestTests,
        .uiPrimitives,
    ]
)

private extension Product {
    
    static let noteNest = library(
        name: .noteNest, 
        targets: [
            .noteNest,
        ]
    )
    
    static let uiPrimitives = library(
        name: .uiPrimitives,
        targets: [
            .uiPrimitives
        ]
    )
}

private extension Target {
    
    static let noteNest = target(name: .noteNest)
    static let noteNestTests = testTarget(
        name: .noteNestTests,
        dependencies: [
            .noteNest
        ]
    )
    
    static let uiPrimitives = target(name: .uiPrimitives)
}

private extension Target.Dependency {
    
    static let noteNest: Self = byName(name: .noteNest)
    
    static let uiPrimitives: Self = byName(name: .uiPrimitives)
}

private extension String {
    
    static let noteNest = "NoteNest"
    static let noteNestTests = "NoteNestTests"
    
    static let uiPrimitives = "UIPrimitives"
}
