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
  version "0.6.5"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "b50a325452f76dbdf7c19e477d36a725cc48217bf6723b9e59e46393cbc69910"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.5/pelagos-mac-vm-0.6.5.tar.gz"
    sha256 "e577bd9142b2eb1250fed0368a1629c8f508d589fc023abd9863ca2909c628f7"
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
    EOS
  end

  test do
    assert_match "pelagos", shell_output("#{bin}/pelagos --help 2>&1")
  end
end
