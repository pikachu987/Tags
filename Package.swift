// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Tags",
    platforms: [.iOS(.v8)],
    products: [
        .library(name: "Tags", targets: ["Tags"]),
    ],
    targets: [
        .target(
            name: "Tags",
            dependencies: [],
            path: "Tags/Classes"
         )
    ]
)
