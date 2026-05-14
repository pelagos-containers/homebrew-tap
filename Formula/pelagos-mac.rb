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
  version "0.6.18"

  url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v#{version}/pelagos-mac-#{version}-aarch64-apple-darwin.tar.gz"
  sha256 "2593f1dc72b2d9d9868e3a30f19c18092e1aab3296ba162a8f7379285574ce71"

  resource "vm" do
    url "https://github.com/pelagos-containers/pelagos-mac/releases/download/v0.6.18/pelagos-mac-vm-0.6.18.tar.gz"
    sha256 "284c139e7bbd7bb3d2cbd6da431826d44d5b3bcd88ff95431e2543bbb40d3e4e"
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
