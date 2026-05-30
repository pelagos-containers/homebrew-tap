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
  version "0.6.19"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "37c80854b2da423d94d504a40f2a50f4ef46ad7ca092cdc5194d3a43d9c8aeb3"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.19/pelagos-mac-vm-0.6.19.tar.gz"
    sha256 "e0e81693d4b6909858a0ae10674ac1d99ba3e52a487c3cc93e585cbd408fcac6"
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

      To upgrade (binary + kernel only — preserves your OCI image cache):
        brew upgrade pelagos-containers/tap/pelagos-mac
        pelagos ping

      To replace the VM disk (destroys OCI image cache — only needed when
      the release notes say the disk format changed):
        pelagos vm stop
        brew upgrade pelagos-containers/tap/pelagos-mac
        pelagos vm init --force
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
