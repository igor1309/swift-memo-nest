// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-note-nest",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .entryListFeature,
        .tools,
        .uiPrimitives,
    ],
    dependencies: [
        .imRx
    ],
    targets: [
        .entryListFeature,
        .entryListFeatureTests,
        .tools,
        .toolsTests,
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
    
    static let tools = library(
        name: .tools,
        targets: [
            .tools,
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
    
    static let entryListFeature = target(
        name: .entryListFeature,
        dependencies: [
            .uiPrimitives,
            .imRx
        ]
    )
    static let entryListFeatureTests = testTarget(
        name: .entryListFeatureTests,
        dependencies: [
            .entryListFeature
        ]
    )
    
    static let tools = target(
        name: .tools,
        dependencies: [
            .uiPrimitives,
            .imRx
        ]
    )
    static let toolsTests = testTarget(
        name: .toolsTests,
        dependencies: [
            .tools
        ]
    )
    
    static let uiPrimitives = target(name: .uiPrimitives)
}

private extension Target.Dependency {
    
    static let entryListFeature: Self = byName(name: .entryListFeature)
    
    static let tools: Self = byName(name: .tools)
    
    static let uiPrimitives: Self = byName(name: .uiPrimitives)
}

private extension String {
    
    static let entryListFeature = "EntryListFeature"
    static let entryListFeatureTests = "EntryListFeatureTests"
    
    static let tools = "Tools"
    static let toolsTests = "ToolsTests"
    
    static let uiPrimitives = "UIPrimitives"
}

// MARK: - external dependencies

private extension Package.Dependency {
    
    static let imRx = Package.Dependency.package(
        url: .igor1309GitHub + .im_Rx,
        branch: "main"
    )
}

private extension Target.Dependency {
    
    static let imRx = product(
        name: .imRx,
        package: .im_Rx
    )
}

private extension String {
    
    static let igor1309GitHub = "https://github.com/igor1309/"
    
    static let imRx = "IMRx"
    static let im_Rx = "swift-imrx"
}
