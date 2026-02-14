import { Gtk } from "ags/gtk4"
import { createBinding } from "ags"
import { execAsync } from "ags/process"
import AstalNetwork from "gi://AstalNetwork"
import AstalBluetooth from "gi://AstalBluetooth"
import AstalBattery from "gi://AstalBattery"

function NetworkIndicator() {
  const network = AstalNetwork.get_default()
  const wifi = network.wifi
  const wired = network.wired

  if (wired) {
    return <image iconName={createBinding(wired, "iconName")} />
  }
  if (wifi) {
    return (
      <box>
        <image
          visible={createBinding(wifi, "enabled")}
          iconName={createBinding(wifi, "iconName")}
        />
        <image
          visible={createBinding(wifi, "enabled")((e) => !e)}
          iconName="network-wireless-disabled-symbolic"
        />
      </box>
    )
  }
  return <image iconName="network-wireless-offline-symbolic" />
}

function BluetoothIndicator() {
  const bt = AstalBluetooth.get_default()
  const adapter = bt.adapter

  if (!adapter) return <box />

  return (
    <image
      visible={createBinding(adapter, "powered")}
      iconName="bluetooth-active-symbolic"
    />
  )
}

function BatteryIndicator() {
  const bat = AstalBattery.get_default()

  return (
    <box
      visible={createBinding(bat, "isBattery")}
      spacing={4}
    >
      <image iconName={createBinding(bat, "batteryIconName")} />
    </box>
  )
}

/* ---------- Quick-settings popover content ---------- */

function NetworkSection() {
  const network = AstalNetwork.get_default()
  const wifi = network.wifi

  if (!wifi) {
    return (
      <box class="qs-row" spacing={8}>
        <image iconName="network-wireless-offline-symbolic" />
        <label label="No Wi-Fi adapter" hexpand xalign={0} />
      </box>
    )
  }

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="qs-section">
      <box spacing={8} class="qs-row">
        <image iconName={createBinding(wifi, "iconName")} />
        <label
          label={createBinding(wifi, "ssid")((s) => s ?? "Wi-Fi")}
          hexpand
          xalign={0}
          class="qs-title"
        />
        <Gtk.Switch
          active={createBinding(wifi, "enabled")}
          valign={Gtk.Align.CENTER}
          onNotifyActive={({ active }) => wifi.set_enabled(active)}
        />
      </box>
    </box>
  )
}

function BluetoothSection() {
  const bt = AstalBluetooth.get_default()
  const adapter = bt.adapter

  if (!adapter) {
    return (
      <box class="qs-row" spacing={8}>
        <image iconName="bluetooth-disabled-symbolic" />
        <label label="No Bluetooth adapter" hexpand xalign={0} />
      </box>
    )
  }

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="qs-section">
      <box spacing={8} class="qs-row">
        <image iconName="bluetooth-active-symbolic" />
        <label label="Bluetooth" hexpand xalign={0} class="qs-title" />
        <Gtk.Switch
          active={createBinding(adapter, "powered")}
          valign={Gtk.Align.CENTER}
          onNotifyActive={({ active }) => {
            adapter.powered = active
          }}
        />
      </box>
    </box>
  )
}

function VolumeSection() {
  const adjustment = new Gtk.Adjustment({
    lower: 0,
    upper: 100,
    value: 50,
    stepIncrement: 5,
    pageIncrement: 10,
  })

  // Fetch current system volume on init
  execAsync("wpctl get-volume @DEFAULT_AUDIO_SINK@")
    .then((out) => {
      const match = out.match(/Volume:\s+([\d.]+)/)
      if (match) adjustment.set_value(parseFloat(match[1]) * 100)
    })
    .catch(() => {})

  return (
    <box orientation={Gtk.Orientation.VERTICAL} class="qs-section">
      <box spacing={8} class="qs-row">
        <image iconName="audio-volume-high-symbolic" />
        <label label="Volume" hexpand xalign={0} class="qs-title" />
      </box>
      <box spacing={8} class="qs-slider-row">
        <image iconName="audio-volume-low-symbolic" />
        <Gtk.Scale
          hexpand
          orientation={Gtk.Orientation.HORIZONTAL}
          adjustment={adjustment}
          onChangeValue={(self) => {
            const val = Math.round(self.get_value())
            execAsync(`wpctl set-volume @DEFAULT_AUDIO_SINK@ ${val}%`).catch(() => {})
            return false
          }}
        />
        <image iconName="audio-volume-high-symbolic" />
      </box>
    </box>
  )
}

function BatterySection() {
  const bat = AstalBattery.get_default()

  return (
    <box
      visible={createBinding(bat, "isBattery")}
      orientation={Gtk.Orientation.VERTICAL}
      class="qs-section"
    >
      <box spacing={8} class="qs-row">
        <image iconName={createBinding(bat, "batteryIconName")} />
        <label
          label={createBinding(bat, "percentage")((p) => `Battery  ${Math.round(p * 100)}%`)}
          hexpand
          xalign={0}
          class="qs-title"
        />
        <label
          label={createBinding(bat, "state")((s) =>
            s === AstalBattery.State.CHARGING ? "Charging" : ""
          )}
          class="qs-dim"
        />
      </box>
    </box>
  )
}

function PowerButtons() {
  return (
    <box class="qs-power-row" spacing={8} halign={Gtk.Align.END}>
      <button
        class="qs-power-btn"
        tooltipText="Settings"
        onClicked={() => execAsync("gnome-control-center").catch(() =>
          execAsync("xdg-open x-scheme-handler/settings").catch(() => {})
        )}
      >
        <image iconName="emblem-system-symbolic" />
      </button>
      <button
        class="qs-power-btn"
        tooltipText="Lock Screen"
        onClicked={() => execAsync("hyprlock").catch(() => {})}
      >
        <image iconName="system-lock-screen-symbolic" />
      </button>
      <button
        class="qs-power-btn"
        tooltipText="Power Off"
        onClicked={() => execAsync("systemctl poweroff").catch(() => {})}
      >
        <image iconName="system-shutdown-symbolic" />
      </button>
    </box>
  )
}

/* ---------- Exported widgets ---------- */

export function SystemIndicators() {
  return (
    <menubutton class="system-indicators">
      <box spacing={4}>
        <NetworkIndicator />
        <BluetoothIndicator />
        <BatteryIndicator />
      </box>
      <popover>
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={4}
          class="quick-settings"
          widthRequest={340}
        >
          <NetworkSection />
          <Gtk.Separator />
          <BluetoothSection />
          <Gtk.Separator />
          <VolumeSection />
          <BatterySection />
          <Gtk.Separator />
          <PowerButtons />
        </box>
      </popover>
    </menubutton>
  )
}
