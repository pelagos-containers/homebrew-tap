# pelagos Homebrew formula (Linux only)
#
# Installs the pelagos container runtime binary for Linux (x86_64 and aarch64).
# This formula is Linux-only; macOS users should use pelagos-mac instead.
#
# Usage:
#   brew tap pelagos-containers/tap
#   brew install pelagos-containers/tap/pelagos

class Pelagos < Formula
  desc "Fast Linux container runtime — OCI-compatible, namespaces, cgroups v2, seccomp, networking"
  homepage "https://github.com/pelagos-containers/pelagos"
  version "0.65.60"
  license "Apache-2.0"

  on_linux do
    on_intel do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-x86_64-linux"
      sha256 "6ae40b3765baa520455b1665ab2d9535cb7a740b3e8579ef677b50d0ec2b9728"
    end

    on_arm do
      url "https://github.com/pelagos-containers/pelagos/releases/download/v#{version}/pelagos-aarch64-linux"
      sha256 "1ff77078ae6d158badbb173379f6c10dafa9c083f2edf6b2aade672df29c7f4c"
    end
  end

  def install
    binary = Hardware::CPU.intel? ? "pelagos-x86_64-linux" : "pelagos-aarch64-linux"
    bin.install binary => "pelagos"
  end

  def caveats
    <<~EOS
      pelagos requires nftables and iproute2. Install them via your system package manager:
        sudo apt-get install -y nftables iproute2    # Debian/Ubuntu
        sudo dnf install -y nftables iproute2        # Fedora/RHEL

      Run the setup script once to initialise the image store and pelagos group:
        sudo pelagos system setup

      Then add yourself to the pelagos group:
        sudo usermod -aG pelagos $USER
      Log out and back in (or run 'newgrp pelagos') for the change to take effect.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pelagos --version 2>&1")
  end
end
