# pelagos-mac Homebrew formula
#
# Installs:
#   pelagos         — macOS CLI (boots VM, proxies commands over vsock)
#   pelagos-docker  — Docker CLI compatibility shim
#   pelagos-tui     — Terminal UI for container management
#
# VM image artifacts (kernel + initramfs + disk placeholder) are installed
# to #{share}/pelagos-mac.  Run `pelagos vm init` once after install to
# write ~/.local/share/pelagos/vm.conf pointing at those artifacts.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install pelagos-containers/tap/pelagos-mac
#   pelagos vm init

class PelagosMac < Formula
  desc "Linux container runtime for Apple Silicon via Virtualization.framework"
  homepage "https://github.com/pelagos-containers/pelagos-mac"
  version "0.6.10"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "2fa370f55c0ac54a3794ca0f5e770d2e4bb1e2d14c8f7abab69d9ae17c13e3e2"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.10/pelagos-mac-vm-0.6.10.tar.gz"
    sha256 "5a00d081c55997add52224632f120be38352b0afd3bdcd816a262e4bfd64aaef"
  end

  def install
    bin.install "pelagos"
    bin.install "pelagos-docker"
    bin.install "pelagos-tui"
    resource("vm").stage { (share/"pelagos-mac").install Dir["*"] }
  end

  def caveats
    <<~EOS
      Run once to initialise the VM configuration:
        pelagos vm init

      This writes ~/.local/share/pelagos/vm.conf pointing at the VM
      artifacts installed to #{share}/pelagos-mac.

      Then verify and run a container:
        pelagos ping
        pelagos run alpine echo hello

      To upgrade:
        brew upgrade pelagos-containers/tap/pelagos-mac
        pelagos vm init --force   # stops old VM, re-inits with new image
        pelagos ping

      To uninstall completely:
        pelagos vm stop
        brew uninstall pelagos-containers/tap/pelagos-mac
        rm -rf ~/.local/share/pelagos   # OCI cache + vm.conf (not removed by brew)
    EOS
  end

  test do
    assert_match "pelagos", shell_output("#{bin}/pelagos --help 2>&1")
  end
end
