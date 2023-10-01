import Cocoa

class Utilities {
    static func isCapslockEnabled() -> Bool {
        return NSEvent.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
    }
    
    static func redCircleImage() -> NSImage {
        let size = NSSize(width: 14, height: 14)
        let image = NSImage(size: size)
        image.lockFocus()
        NSColor.red.set()
        NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        image.unlockFocus()
        return image
    }
}
