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
  version "0.6.14"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "9d43ae5fdb9b5adb73b2ced1dac15a835c583eb4f3161d887112a126bab1878f"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.14/pelagos-mac-vm-0.6.14.tar.gz"
    sha256 "8035c79e3c1384cf7ab60d8a15cae11c2ad95922525a3fe7545e5360779cb43b"
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
