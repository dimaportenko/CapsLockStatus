//
//  AppDelegate.swift
//  CapsLockStatus
//
//  Created by Dmitriy Portenko on 30.09.2023.
//

import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!

    func applicationDidFinishLaunching(_: Notification) {
        do {
            if SMAppService.mainApp.status != .enabled {
                try SMAppService.mainApp.register()
            }
        } catch {
            print("failed to enable launch at login: \(error.localizedDescription)")
        }

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu

        updateMenuBarIcon(isCapsLockOn: isCapslockEnabled())

        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged, handler: { [weak self] _ in
            guard let self = self else { return }
            let isOn = self.isCapslockEnabled()
            self.updateMenuBarIcon(isCapsLockOn: isOn)
        })
    }

    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }

    func isCapslockEnabled() -> Bool {
        return NSEvent.modifierFlags.intersection(.deviceIndependentFlagsMask).contains(.capsLock)
    }

    func redCircleImage() -> NSImage {
        let size = NSSize(width: 14, height: 14)
        let image = NSImage(size: size)

        image.lockFocus()
        NSColor.red.set()
        NSBezierPath(ovalIn: NSRect(x: 0, y: 0, width: size.width, height: size.height)).fill()
        image.unlockFocus()

        return image
    }

    func updateMenuBarIcon(isCapsLockOn: Bool) {
        if isCapsLockOn {
            let image = redCircleImage()

            statusItem.button?.image = image
        } else {
            statusItem.button?.image = nil
        }
    }
}
