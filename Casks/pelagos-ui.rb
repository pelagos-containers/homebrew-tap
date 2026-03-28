# pelagos-ui Homebrew cask
#
# Installs pelagos-ui.app — desktop GUI for the pelagos container runtime.
# Requires pelagos-mac: brew install pelagos-containers/tap/pelagos-mac
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install --cask pelagos-containers/tap/pelagos-ui

cask "pelagos-ui" do
  version "0.1.0"

  sha256 "2c2e5b4e60d93806fbde4af8850e863a8269424c95f27778d9ead936bcdfd46d"
  url "https://github.com/pelagos-containers/pelagos-ui/releases/download/v#{version}/pelagos-ui_#{version}_aarch64.dmg"

  name "pelagos-ui"
  desc "Desktop GUI for the pelagos container runtime"
  homepage "https://github.com/pelagos-containers/pelagos-ui"

  app "pelagos-ui.app"

  # Ad-hoc signed only — remove Gatekeeper quarantine after install.
  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/pelagos-ui.app"]
  end

  zap trash: [
    "~/Library/Logs/io.pelagos.ui",
    "~/Library/WebKit/io.pelagos.ui",
    "~/Library/Application Support/io.pelagos.ui",
  ]
end
