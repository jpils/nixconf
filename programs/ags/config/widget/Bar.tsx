import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { For, createBinding } from "ags"
import { createPoll } from "ags/time"
import GLib from "gi://GLib"
import AstalHyprland from "gi://AstalHyprland"
import { SystemIndicators } from "./QuickSettings"

function Workspaces() {
  const hypr = AstalHyprland.get_default()!
  const workspaces = createBinding(hypr, "workspaces")
  const focused = createBinding(hypr, "focusedWorkspace")

  return (
    <box class="workspaces">
      <For each={workspaces((ws) =>
        ws
          .filter((w) => !(w.id >= -99 && w.id <= -2))
          .sort((a, b) => a.id - b.id)
      )}>
        {(ws) => (
          <button
            class={focused((fw) => fw === ws ? "focused" : "")}
            onClicked={() => ws.focus()}
          >
            <label label={String(ws.id)} />
          </button>
        )}
      </For>
    </box>
  )
}

function FocusedWindow() {
  const hypr = AstalHyprland.get_default()!
  const focused = createBinding(hypr, "focusedClient")

  return (
    <box class="focused-window">
      <label
        label={focused((client) => client?.title ?? "")}
        maxWidthChars={40}
        ellipsize={3}
      />
    </box>
  )
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 5000, () => {
    return GLib.DateTime.new_now_local().format("%a %b %-e  %-l:%M %p")!
  })

  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={app}
    >
      <centerbox cssName="centerbox">
        <box $type="start" spacing={4}>
          <Workspaces />
          <FocusedWindow />
        </box>
        <menubutton $type="center" class="clock">
          <label label={time} />
          <popover>
            <Gtk.Calendar />
          </popover>
        </menubutton>
        <box $type="end" spacing={4}>
          <SystemIndicators />
        </box>
      </centerbox>
    </window>
  )
}
