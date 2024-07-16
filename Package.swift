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
        .entryListFeature,
        .uiPrimitives,
    ],
    targets: [
        .entryListFeature,
        .entryListFeatureTests,
        .uiPrimitives,
    ]
)

private extension Product {
    
    static let entryListFeature = library(
        name: .entryListFeature,
        targets: [
            .entryListFeature,
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
    
    static let entryListFeature = target(name: .entryListFeature)
    static let entryListFeatureTests = testTarget(
        name: .entryListFeatureTests,
        dependencies: [
            .entryListFeature
        ]
    )
    
    static let uiPrimitives = target(name: .uiPrimitives)
}

private extension Target.Dependency {
    
    static let entryListFeature: Self = byName(name: .entryListFeature)
    
    static let uiPrimitives: Self = byName(name: .uiPrimitives)
}

private extension String {
    
    static let entryListFeature = "EntryListFeature"
    static let entryListFeatureTests = "EntryListFeatureTests"
    
    static let uiPrimitives = "UIPrimitives"
}
