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
  version "0.6.6"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "9451a4da244cc3dfd5ea41fe21f9e1b8b6211943fea06a6aa1eb184468a84d5e"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.6/pelagos-mac-vm-0.6.6.tar.gz"
    sha256 "ccdc32b896c320272a630e4d37f0e7721dc9ed579e711a8cfa391474be8ddc13"
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
