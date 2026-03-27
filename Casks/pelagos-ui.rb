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

  # NOTE: URL and SHA256 are placeholders until CI release artifacts exist.
  # See https://github.com/pelagos-containers/homebrew-tap/issues/1
  sha256 "PLACEHOLDER"
  url "https://github.com/pelagos-containers/pelagos-ui/releases/download/v#{version}/pelagos-ui-#{version}-aarch64.dmg"

  name "pelagos-ui"
  desc "Desktop GUI for the pelagos container runtime"
  homepage "https://github.com/pelagos-containers/pelagos-ui"

  app "pelagos-ui.app"

  zap trash: [
    "~/Library/Logs/io.pelagos.ui",
    "~/Library/WebKit/io.pelagos.ui",
    "~/Library/Application Support/io.pelagos.ui",
  ]
end
