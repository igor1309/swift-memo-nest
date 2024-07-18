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
        .entryEditorFeature,
        .entryListFeature,
        .sortBuilderFeature,
        .tools,
        .uiPrimitives,
    ],
    dependencies: [
        .customDump,
        .imRx
    ],
    targets: [
        .entryEditorFeature,
        .entryListFeature,
        .entryListFeatureTests,
        .sortBuilderFeature,
        .sortBuilderFeatureTests,
        .tools,
        .toolsTests,
        .uiPrimitives,
    ]
)

private extension Product {
    
    static let entryEditorFeature = library(
        name: .entryEditorFeature,
        targets: [
            .entryEditorFeature,
        ]
    )
    
    static let entryListFeature = library(
        name: .entryListFeature,
        targets: [
            .entryListFeature,
        ]
    )
    
    static let sortBuilderFeature = library(
        name: .sortBuilderFeature,
        targets: [
            .sortBuilderFeature,
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
    
    static let entryEditorFeature = target(
        name: .entryEditorFeature
    )
    
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
            .customDump,
            .entryListFeature
        ]
    )
    
    static let sortBuilderFeature = target(
        name: .sortBuilderFeature,
        dependencies: [
            .uiPrimitives,
            .imRx
        ]
    )
    static let sortBuilderFeatureTests = testTarget(
        name: .sortBuilderFeatureTests,
        dependencies: [
            .customDump,
            .sortBuilderFeature
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
            .customDump,
            .tools
        ]
    )
    
    static let uiPrimitives = target(name: .uiPrimitives)
}

private extension Target.Dependency {
    
    static let entryEditorFeature: Self = byName(name: .entryListFeature)
    
    static let entryListFeature: Self = byName(name: .entryListFeature)
    
    static let sortBuilderFeature: Self = byName(name: .sortBuilderFeature)
    
    static let tools: Self = byName(name: .tools)
    
    static let uiPrimitives: Self = byName(name: .uiPrimitives)
}

private extension String {
    
    static let entryEditorFeature = "EntryEditorFeature"
    
    static let entryListFeature = "EntryListFeature"
    static let entryListFeatureTests = "EntryListFeatureTests"
    
    static let sortBuilderFeature = "SortBuilderFeature"
    static let sortBuilderFeatureTests = "SortBuilderFeatureTests"
    
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

// MARK: - Point-Free

private extension Package.Dependency {
    
    static let casePaths = Package.Dependency.package(
        url: .pointFreeGitHub + .case_paths,
        from: .init(1, 4, 2)
    )
    static let combineSchedulers = Package.Dependency.package(
        url: .pointFreeGitHub + .combine_schedulers,
        from: .init(1, 0, 0)
    )
    static let customDump = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_custom_dump,
        from: .init(1, 3, 0)
    )
    static let identifiedCollections = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_identified_collections,
        from: .init(1, 1, 0)
    )
    static let snapshotTesting = Package.Dependency.package(
        url: .pointFreeGitHub + .swift_snapshot_testing,
        from: .init(1, 16, 2)
    )
    static let swiftUINavigation = Package.Dependency.package(
        url: .pointFreeGitHub + .swiftUI_navigation,
        from: .init(1, 5, 0)
    )
}

private extension Target.Dependency {
    
    static let casePaths = product(
        name: .casePaths,
        package: .case_paths
    )
    static let combineSchedulers = product(
        name: .combineSchedulers,
        package: .combine_schedulers
    )
    static let customDump = product(
        name: .customDump,
        package: .swift_custom_dump
    )
    static let identifiedCollections = product(
        name: .identifiedCollections,
        package: .swift_identified_collections
    )
    static let snapshotTesting = product(
        name: .snapshotTesting,
        package: .swift_snapshot_testing
    )
    static let swiftUINavigation = product(
        name: .swiftUINavigation,
        package: .swiftUI_navigation
    )
}

private extension String {
    
    static let pointFreeGitHub = "https://github.com/pointfreeco/"
    
    static let casePaths = "CasePaths"
    static let case_paths = "swift-case-paths"
    
    static let combineSchedulers = "CombineSchedulers"
    static let combine_schedulers = "combine-schedulers"
    
    static let customDump = "CustomDump"
    static let swift_custom_dump = "swift-custom-dump"
    
    static let identifiedCollections = "IdentifiedCollections"
    static let swift_identified_collections = "swift-identified-collections"
    
    static let snapshotTesting = "SnapshotTesting"
    static let swift_snapshot_testing = "swift-snapshot-testing"
    
    static let swiftUINavigation = "SwiftUINavigation"
    static let swiftUI_navigation = "swiftui-navigation"
}
