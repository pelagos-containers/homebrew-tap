cask "pelagos-ui" do
  version "0.1.6"
  sha256 "f312becb9ab8b505dce8075811706645beedf3876072f1ce65156b8ec8cf1f70"

  url "https://github.com/pelagos-containers/pelagos-ui/releases/download/v#{version}/Pelagos_#{version}_aarch64.dmg"
  name "Pelagos"
  desc "Desktop GUI for the pelagos container runtime"
  homepage "https://github.com/pelagos-containers/pelagos-ui"

  depends_on formula: "pelagos-containers/tap/pelagos-mac"

  app "Pelagos.app"

  uninstall quit: "io.pelagos.ui"

  zap trash: [
    "~/Library/Logs/io.pelagos.ui",
    "~/Library/WebKit/io.pelagos.ui",
    "~/Library/Application Support/io.pelagos.ui",
  ]
end
