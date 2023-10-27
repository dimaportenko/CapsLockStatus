//
//  NSImage+TintColor.swift
//  CapsLockStatus
//
//  Created by Dmitriy Portenko on 27.10.2023.
//


import Cocoa

// This will work with Swift 5
extension NSImage {
    func image(with tintColor: NSColor) -> NSImage {
        if self.isTemplate == false {
            return self
        }
        
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        tintColor.set()
        
        let imageRect = NSRect(origin: .zero, size: image.size)
        imageRect.fill(using: .sourceIn)
        
        image.unlockFocus()
        image.isTemplate = false
        
        return image
    }
}
