import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { For, createBinding } from "ags"
import { createPoll } from "ags/time"
import { execAsync } from "ags/process"
import GLib from "gi://GLib"
import AstalHyprland from "gi://AstalHyprland"
import AstalNetwork from "gi://AstalNetwork"

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

function Network() {
  const network = AstalNetwork.get_default()
  const wifi = network.wifi
  const wired = network.wired
  const primary = createBinding(network, "primary")

  const sorted = (arr: Array<AstalNetwork.AccessPoint>) => {
    return arr.filter((ap) => !!ap.ssid).sort((a, b) => b.strength - a.strength)
  }

  return (
    <menubutton class="network">
      {/* bar icon — always visible */}
      <box>
        {wired && (
          <image
            visible={primary((t) => t === AstalNetwork.Primary.WIRED)}
            iconName={createBinding(wired, "iconName")}
          />
        )}
        {wifi && (
          <image
            visible={createBinding(wifi, "enabled")}
            iconName={createBinding(wifi, "iconName")}
          />
        )}
        {wifi ? (
          <image
            visible={createBinding(wifi, "enabled")((e) => !e)}
            iconName="network-wireless-disabled-symbolic"
          />
        ) : (
          <image iconName="network-wireless-offline-symbolic" />
        )}
      </box>

      {/* popover */}
      <popover>
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={4}
          class="network-panel"
          widthRequest={300}
        >
          {/* --- Wired section --- */}
          {wired && (
            <box orientation={Gtk.Orientation.VERTICAL} class="section">
              <box spacing={8} class="section-header">
                <image iconName={createBinding(wired, "iconName")} />
                <label label="Wired" hexpand xalign={0} class="section-title" />
                <label
                  label={createBinding(wired, "speed")((s) => s > 0 ? `${s} Mb/s` : "")}
                  class="dim"
                />
              </box>
            </box>
          )}

          {/* --- Wifi section --- */}
          {wifi ? (
            <box orientation={Gtk.Orientation.VERTICAL} class="section">
              <box spacing={8} class="section-header">
                <image iconName={createBinding(wifi, "enabled")((e) =>
                  e ? "network-wireless-symbolic" : "network-wireless-disabled-symbolic"
                )} />
                <label label="Wi-Fi" hexpand xalign={0} class="section-title" />
                <Gtk.Switch
                  active={createBinding(wifi, "enabled")}
                  valign={Gtk.Align.CENTER}
                  onNotifyActive={({ active }) => {
                    wifi.set_enabled(active)
                  }}
                />
              </box>

              {/* Connected network info */}
              <box
                visible={createBinding(wifi, "ssid")((s) => !!s)}
                spacing={8}
                class="connected-info"
              >
                <label
                  label={createBinding(wifi, "ssid")((s) => s ?? "")}
                  hexpand
                  xalign={0}
                  class="connected-ssid"
                />
                <label label="Connected" class="dim" />
              </box>

              {/* Disabled message */}
              <label
                visible={createBinding(wifi, "enabled")((e) => !e)}
                label="Wi-Fi is turned off"
                class="dim disabled-info"
                xalign={0}
                marginStart={8}
                marginEnd={8}
                marginTop={8}
                marginBottom={8}
              />

              {/* Access point list */}
              <Gtk.Separator visible={createBinding(wifi, "enabled")} />
              <box
                orientation={Gtk.Orientation.VERTICAL}
                visible={createBinding(wifi, "enabled")}
                class="ap-list"
              >
                <For each={createBinding(wifi, "accessPoints")(sorted)}>
                  {(ap: AstalNetwork.AccessPoint) => (
                    <button
                      class="ap-item"
                      onClicked={(self) => {
                        const popover = self.get_ancestor(Gtk.Popover) as Gtk.Popover | null
                        popover?.popdown()
                        execAsync(`nmcli d wifi connect ${ap.bssid}`).catch(() => {})
                      }}
                    >
                      <box spacing={8}>
                        <image iconName={createBinding(ap, "iconName")} />
                        <label label={createBinding(ap, "ssid")} hexpand xalign={0} />
                        <image
                          iconName="object-select-symbolic"
                          visible={createBinding(
                            wifi,
                            "activeAccessPoint",
                          )((active) => active === ap)}
                        />
                      </box>
                    </button>
                  )}
                </For>
              </box>
            </box>
          ) : (
            <box class="section" spacing={8} marginStart={8} marginEnd={8} marginTop={8} marginBottom={8}>
              <image iconName="network-wireless-offline-symbolic" />
              <label label="No Wi-Fi Adapter Found" class="dim" />
            </box>
          )}

          {/* --- Settings button --- */}
          <Gtk.Separator />
          <button
            class="settings-btn"
            onClicked={(self) => {
              const popover = self.get_ancestor(Gtk.Popover) as Gtk.Popover | null
              popover?.popdown()
              execAsync("nm-connection-editor").catch(() => {})
            }}
          >
            <box spacing={8}>
              <image iconName="emblem-system-symbolic" />
              <label label="Network Settings" />
            </box>
          </button>
        </box>
      </popover>
    </menubutton>
  )
}

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 5000, () => {
    return GLib.DateTime.new_now_local().format("%-e %b  %-l:%M %p")!
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
        <box $type="start">
          <Workspaces />
        </box>
        <menubutton $type="center" class="clock">
          <label label={time} />
          <popover>
            <Gtk.Calendar />
          </popover>
        </menubutton>
        <box $type="end">
          <Network />
        </box>
      </centerbox>
    </window>
  )
}
