# pelagos-ui Homebrew cask
#
# Installs Pelagos.app — desktop GUI for the pelagos container runtime.
# pelagos-mac is installed automatically as a dependency.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install --cask pelagos-containers/tap/pelagos-ui

cask "pelagos-ui" do
  version "0.1.6"
  sha256 "0081f04bd755689ab46b1ef55f05b4607938391fb60bbca4262d617b56a064ab"

  url "https://github.com/pelagos-containers/pelagos-ui/releases/download/v#{version}/Pelagos_#{version}_aarch64.dmg"
  name "Pelagos"
  desc "Desktop GUI for the pelagos container runtime"
  homepage "https://github.com/pelagos-containers/pelagos-ui"

  # Requires the pelagos-mac CLI + VM layer.
  # TODO: change to cask dependency once pelagos-mac migrates to cask (issue #222).
  depends_on formula: "pelagos-containers/tap/pelagos-mac"

  app "Pelagos.app"

  uninstall quit: "io.pelagos.ui"

  zap trash: [
    "~/Library/Logs/io.pelagos.ui",
    "~/Library/WebKit/io.pelagos.ui",
    "~/Library/Application Support/io.pelagos.ui",
  ]
end
