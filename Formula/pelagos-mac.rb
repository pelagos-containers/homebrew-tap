# pelagos-mac Homebrew formula
#
# Installs:
#   pelagos         — macOS CLI (boots VM, proxies commands over vsock)
#   pelagos-docker  — Docker CLI compatibility shim
#   pelagos-tui     — Terminal UI for container management
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
  version "0.5.0"

  # NOTE: URLs and SHA256s are placeholders until CI release artifacts exist.
  # See https://github.com/pelagos-containers/homebrew-tap/issues/1
  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "PLACEHOLDER"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-vm-#{version}.tar.gz"
    sha256 "PLACEHOLDER"
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
