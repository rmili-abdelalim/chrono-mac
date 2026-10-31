import Cocoa

final class ChronoApp: NSObject, NSApplicationDelegate, NSMenuDelegate {
    var item: NSStatusItem!
    let menu = NSMenu()
    var timer: Timer?
    var startDate: Date?
    var accumulated: TimeInterval = 0
    var laps: [TimeInterval] = []

    var running: Bool { startDate != nil }
    var current: TimeInterval {
        accumulated + (startDate.map { Date().timeIntervalSince($0) } ?? 0)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.autosaveName = "ChronoMenuBar"
        if let button = item.button {
            button.image = NSImage(systemSymbolName: "stopwatch", accessibilityDescription: "Chronomètre")
            button.imagePosition = .imageLeading
        }
        menu.delegate = self
        item.menu = menu
        refreshTitle()
    }

    func format(_ t: TimeInterval) -> String {
        let total = Int(t * 100)
        let cs = total % 100
        let s = (total / 100) % 60
        let m = (total / 6000) % 60
        let h = total / 360000
        if h > 0 { return String(format: "%d:%02d:%02d,%02d", h, m, s, cs) }
        return String(format: "%02d:%02d,%02d", m, s, cs)
    }

    func refreshTitle() {
        let attrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .medium)
        ]
        item.button?.attributedTitle = NSAttributedString(string: " " + format(current), attributes: attrs)
    }

    func menuNeedsUpdate(_ menu: NSMenu) { build() }

    func add(_ title: String, _ action: Selector?, key: String = "", enabled: Bool = true) {
        let mi = NSMenuItem(title: title, action: action, keyEquivalent: key)
        mi.target = self
        mi.isEnabled = enabled
        menu.addItem(mi)
    }

    func build() {
        menu.removeAllItems()
        menu.autoenablesItems = false
        let label = running ? "Arrêter" : (accumulated > 0 ? "Reprendre" : "Démarrer")
        add(label, #selector(toggleRun), key: "s")
        add("Tour", #selector(lap), key: "t", enabled: running)
        add("Réinitialiser", #selector(reset), key: "r", enabled: !running && accumulated > 0)

        if !laps.isEmpty {
            menu.addItem(.separator())
            add("Tours       Temps du tour     Total", nil, enabled: false)
            for i in stride(from: laps.count - 1, through: 0, by: -1) {
                let split = laps[i] - (i > 0 ? laps[i - 1] : 0)
                add(String(format: "%02d", i + 1) + "            " + format(split) + "        " + format(laps[i]), nil, enabled: false)
            }
        }
        menu.addItem(.separator())
        add("Quitter le chronomètre", #selector(quit), key: "q")
    }

    @objc func toggleRun() {
        if running {
            accumulated = current
            startDate = nil
            timer?.invalidate()
            timer = nil
        } else {
            startDate = Date()
            let t = Timer(timeInterval: 0.03, repeats: true) { [weak self] _ in self?.refreshTitle() }
            RunLoop.main.add(t, forMode: .common)
            timer = t
        }
        refreshTitle()
    }

    @objc func lap() { laps.append(current) }

    @objc func reset() {
        accumulated = 0
        laps = []
        refreshTitle()
    }

    @objc func quit() { NSApp.terminate(nil) }
}

let app = NSApplication.shared
let delegate = ChronoApp()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
