# pelagos-mac Homebrew formula
#
# Installs:
#   pelagos         â macOS CLI (boots VM, proxies commands over vsock)
#   pelagos-docker  â Docker CLI compatibility shim
#   pelagos-tui     â Terminal UI for container management
#
# VM image artifacts (kernel + initramfs + disk placeholder) are installed
# to #{share}/pelagos-mac and loaded automatically on first `pelagos vm start`.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install pelagos-containers/tap/pelagos-mac

class PelagosMac < Formula
  desc "Linux container runtime for Apple Silicon via Virtualization.framework"
  homepage "https://github.com/pelagos-containers/pelagos-mac"
  version "0.6.1"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "fa5d8b2fefd78b5f3acf44a5746c17cb375699f7f077de731767bad1cc7f53a6"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-vm-#{version}.tar.gz"
    sha256 "2f66cf0ac0f3dbb07535eefff889536e367a71223e695833ac409e29c3b4b4dd"
  end

  def install
    bin.install "pelagos"
    bin.install "pelagos-docker"
    bin.install "pelagos-tui"
    resource("vm").stage { (share/"pelagos-mac").install Dir["*"] }
  end

  test do
    assert_match "pelagos", shell_output("#{bin}/pelagos --help 2>&1")
  end
end
