import Cocoa
import ServiceManagement

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    
    func applicationDidFinishLaunching(_: Notification) {
        initializeAppService()
        initializeStatusMenu()
        monitorCapsLockChanges()
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(self)
    }
    
    private func initializeAppService() {
        do {
            if SMAppService.mainApp.status != .enabled {
                try SMAppService.mainApp.register()
            }
        } catch {
            print("failed to enable launch at login: \(error.localizedDescription)")
        }
    }
    
    private func initializeStatusMenu() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        statusItem.menu = menu
        updateMenuBarIcon(isCapsLockOn: Utilities.isCapslockEnabled())
    }
    
    private func monitorCapsLockChanges() {
        NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] _ in
            guard let self = self else { return }
            let isOn = Utilities.isCapslockEnabled()
            self.updateMenuBarIcon(isCapsLockOn: isOn)
        }
    }
    
    private func updateMenuBarIcon(isCapsLockOn: Bool) {
        let imageName = "capslock-outlined"
        guard let image = NSImage(named: imageName) else {
            print("Image named \(imageName) not found")
            return
        }
        
        image.isTemplate = true  // Allow tinting
        let coloredImage = isCapsLockOn ? image.image(with: NSColor.systemRed) : image.image(with: NSColor.white)
        statusItem.button?.image = coloredImage
        //        statusItem.button?.contentTintColor = isCapsLockOn ? NSColor.systemRed : NSColor.systemGray
    }
}
