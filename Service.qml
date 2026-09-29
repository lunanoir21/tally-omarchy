import QtQuick
import Quickshell
import "./tally/ui" as Tally

// Omarchy entry point for the "service" kind. Tally counts focused-window
// time in the background and owns its own layer-shell windows (the card, the
// theme picker, the first-run tour), so TallyHost only has to exist once.
//
// Omarchy's bar is not ours to put a widget into, so the pill gets a small
// window of its own at the top-right corner, just under the bar. Hide it in
// Settings ("Always show in the bar") and open the card with a keybind:
//   qs ipc call lunanoir.tally-screentime toggle
Scope {
    Tally.TallyHost {}

    PanelWindow {
        id: pillWindow
        screen: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
        anchors { top: true; right: true }
        margins { top: 40; right: 12 }
        implicitWidth: pill.implicitWidth
        implicitHeight: 40
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore

        Tally.TallyPill {
            id: pill
            anchors.centerIn: parent
            size: 40
            barTop: 40
            barLeft: 0
            screenName: pillWindow.screen ? pillWindow.screen.name : ""
        }
    }
}
