//
//  URL+localURLForXCAssets.swift
//  SwiftLearning
//
//  Created by Filip Cybuch on 26/07/2022.
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// https://stackoverflow.com/questions/21769092/can-i-get-a-nsurl-from-an-xcassets-bundle
extension URL {
    static func localURLForXCAssets(imageName: String) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let url = cacheDirectory.appendingPathComponent("\(imageName).png")
        let path = url.path
        if !fileManager.fileExists(atPath: path) {
            #if os(macOS)
            guard let image = NSImage(named: imageName), let data = image.png else { return nil }
            #elseif os(iOS)
            guard let image = UIImage(named: imageName), let data = image.pngData() else { return nil }
            #endif
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
        }
        return url
    }
}

//https://stackoverflow.com/questions/29262624/nsimage-to-nsdata-as-png-swift
#if os(macOS)
private extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
private extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
private extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
#endif
