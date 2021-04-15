// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "OneTimePasscodeField",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "OneTimePasscodeField", targets: ["OneTimePasscodeField"]),
    ],
    targets: [
        .target(name: "OneTimePasscodeField"),
    ]
)
