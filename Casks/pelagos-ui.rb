# pelagos-ui Homebrew cask
#
# Installs Pelagos.app — desktop GUI for the pelagos container runtime.
# pelagos-mac is installed automatically as a dependency.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install --cask pelagos-containers/tap/pelagos-ui

cask "pelagos-ui" do
  version "0.1.5"
  sha256 "d3e3d4af993311e026b3a8fad7f44af8344487eebb61af7d80248461350b3331"

  url "https://github.com/pelagos-containers/pelagos-ui/releases/download/v#{version}/Pelagos_#{version}_aarch64.dmg"
  name "Pelagos"
  desc "Desktop GUI for the pelagos container runtime"
  homepage "https://github.com/pelagos-containers/pelagos-ui"

  # Requires the pelagos-mac CLI + VM layer.
  # TODO: change to cask dependency once pelagos-mac migrates to cask (issue #222).
  depends_on formula: "pelagos-containers/tap/pelagos-mac"

  app "Pelagos.app"

  # Ad-hoc signed only — remove Gatekeeper quarantine after install.
  # TODO: remove postflight once Developer ID signing + notarization is in place (epic #225).
  postflight do
    system_command "/usr/bin/xattr",
      args: ["-dr", "com.apple.quarantine", "#{appdir}/Pelagos.app"]
  end

  uninstall quit: "io.pelagos.ui"

  zap trash: [
    "~/Library/Logs/io.pelagos.ui",
    "~/Library/WebKit/io.pelagos.ui",
    "~/Library/Application Support/io.pelagos.ui",
  ]
end
